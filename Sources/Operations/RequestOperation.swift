//
//  NetworkOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

// TODO: document this
class RequestOperation<Output>: AsyncOperation {
    
    // MARK: - Properties
    
    // TODO: document this
    private weak var urlSession: URLSession?
    // TODO: document this
    private let builder: DecodableRequest<Output>
    // TODO: document this
    private let completion: (Result<Output, NKError.RequestError>) -> Void
    
    // MARK: - Optional properties
    
    /// The baseUrl to inject to the request.
    var baseURL: URL?
    /// Modifies the urlRequest.
    var modifier: RequestModifier?
    /// Observes the urlRequest.
    var observer: RequestObserver?
    // TODO: document this
    private var urlRequest: URLRequest?
    // TODO: document this
    private var task: URLSessionDataTask?
    
    // MARK: - Lifecycle
    
    init(
        urlSession: URLSession,
        request: DecodableRequest<Output>,
        _ completion: @escaping (Result<Output, NKError.RequestError>) -> Void
    ) {
        self.urlSession = urlSession
        self.builder = request
        self.completion = completion
    }
    
    private func prepare() {
        // replace url if needed
        if !builder.components.options.contains(.enforceURL), let baseURL = self.baseURL {
            builder.components.url = baseURL
        }
        // attempt to create the urlRequest
        var urlRequest: URLRequest
        do {
            urlRequest = try builder.build()
        } catch let error {
            fail(error: .genericError(error))
            cancel()
            return
        }
        // modify the urlRequest if needed
        modifier.map { $0.modify(&urlRequest) }
        // notify observer
        observer.map { $0.requestWillLoad(urlRequest) }
        // assign urlRequest
        self.urlRequest = urlRequest
    }
    
    override func main() {
        // prepare for the request's execution
        self.prepare()
        // validate urlRequest exists
        guard let urlRequest = urlRequest else { return }
        // create the data task
        task = urlSession?.dataTask(for: urlRequest) { [weak self] (result) in
            // avoid retain cycle
            guard let self = self else { return }
            // state should be finished after completing data task
            defer { self.state = .finished }
            // check if it wasn't cancelled
            if self.isCancelled || self.isFinished { return }
            // check the result
            switch result {
            // if got a generic error, the request failed without much detail
            case .genericFailure(let error):
                self.fail(error: .genericError(error))
            // if got a network related error
            case .localFailure(let error):
                self.fail(error: .localError(error))
            // if got a client-side error
            case .clientFailure(let data, let response):
                self.didLoad(response: response)
                self.fail(error: .clientError(data, response.statusCode))
            // if got a server-side error
            case .serverFailure(let response):
                self.didLoad(response: response)
                self.fail(error: .serverError(response.statusCode))
            // if succeeded
            case .success(let raw, let response):
                // notify the request did load
                self.didLoad(response: response, serverOutput: raw)
                // attempt to transform the raw response
                switch Result(catching: { try self.builder.internalDecode(raw, response.statusCode) }) {
                // if failed to transform, notify error
                case .failure(let error):
                    self.fail(error: .genericError(error))
                // if succeeded
                case .success(let output):
                    self.succeed(output: output)
                }
            }
        }
        // start the data task
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel() // stop task
    }
    
    /// The method that handles the server's response
    private func didLoad(
        response: HTTPURLResponse,
        serverOutput: Data? = nil
    ) {
        guard let obs = self.observer, let req = self.urlRequest else { return }
        obs.requestDidLoad(req, response: response, rawValue: serverOutput)
    }
    
    /// The method that handles the request's failure.
    private func fail(error: NKError.RequestError) {
        // notify observer
        if let obs = self.observer, let req = self.urlRequest {
            obs.requestDidFail(req, error: error)
        }
        completion(.failure(error))
    }

    /// The method that handles the request's success.
    private func succeed(output: Output) {
        // notify observer
        if let obs = self.observer, let req = self.urlRequest {
            obs.requestDidSucceed(req, value: output)
        }
        completion(.success(output))
    }
    
}
