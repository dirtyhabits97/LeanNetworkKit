//
//  NetworkOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

final class RequestOperation<AnyRequest: Request>: AsyncOperation {
    
    // MARK: - Properties
    
    private weak var urlSession: URLSession?
    
    private let request: AnyRequest
    private let completion: (Result<AnyRequest.Response, Error>) -> Void
    
    private var dataTask: URLSessionDataTask?
    
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
            urlRequest = try getUrlRequest()
        } catch let error {
            completion(.failure(error))
            state = .finished
            return
        }
        // create the data task
        dataTask = urlSession?.dataTask(for: urlRequest) { [weak self] (result) in
            guard let self = self else { return } // avoid retain cycle
            defer { self.state = .finished } // state should be finished after completing data task
            guard !self.isCancelled else { return } // check if it wasn't cancelled
            let newResult = result.map(self.request.decode) // result with response type
            self.completion(newResult) // completion block execution
        }
        dataTask?.resume()
    }
    
    public override func cancel() {
        super.cancel()
        dataTask?.cancel()
    }
    
}

private extension RequestOperation {
    
    func getUrlRequest() throws -> URLRequest {
        return try URLRequest(request: request)
    }
    
}

private extension RequestOperation where AnyRequest: EncodableRequest {
    
    func getUrlRequest() throws -> URLRequest {
        return try URLRequest(encodableRequest: request)
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
