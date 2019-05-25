//
//  NetworkOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

class RequestOperation<AnyRequest: Request>: AsyncOperation {
    
    // MARK: - Properties
    
    private weak var urlSession: URLSession?
    
    private let request: AnyRequest
    private let completion: (Result<AnyRequest.Response, Error>) -> Void
    
    private var dataTask: URLSessionDataTask?
    
    var toUrlRequest: (AnyRequest) throws -> URLRequest {
        return { request in try URLRequest(request: request) }
    }
    // MARK: - Lifecycle
    
    init(
        urlSession: URLSession,
        request: AnyRequest,
        _ completion: @escaping (Result<AnyRequest.Response, Error>) -> Void
    ) {
        self.urlSession = urlSession
        self.request = request
        self.completion = completion
    }
    
    public override func main() {
        // attempt to create the url request
        let urlRequest: URLRequest
        do {
            urlRequest = try toUrlRequest(request)
        } catch let error {
            completion(.failure(error))
            state = .finished
            return
        }
        // create the data task
        dataTask = urlSession?.dataTask(for: urlRequest) { [weak self] (result) in
            // avoid retain cycle
            guard let self = self else { return }
            // state should be finished after completing data task
            defer { self.state = .finished }
            // check if it wasn't cancelled
            guard !self.isCancelled else { return }
            // result with response type
            let newResult = result.map(self.request.decode)
            // completion block execution
            self.completion(newResult)
        }
        dataTask?.resume()
    }
    
    public override func cancel() {
        super.cancel()
        dataTask?.cancel()
    }
    
}

private extension Result where Failure == Error {
    
    func map<NewSuccess>(
        _ transform: (Success) throws -> NewSuccess
    ) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value): return .init { try transform(value) }
        case .failure(let error): return .failure(error)
        }
    }
    
}
