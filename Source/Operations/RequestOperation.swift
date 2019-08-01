//
//  NetworkOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

class RequestOperation<Request: LeanNetworkKit.Request>: AsyncOperation {
    
    // MARK: - Properties
    
    private weak var urlSession: URLSession?
    
    private let request: Request
    private let completion: (Result<Request.Response, Error>) -> Void
    
    private var task: URLSessionDataTask?
    
    // MARK: - Lifecycle
    
    init(
        urlSession: URLSession,
        request: Request,
        _ completion: @escaping (Result<Request.Response, Error>) -> Void
    ) {
        self.urlSession = urlSession
        self.request = request
        self.completion = completion
    }
    
    override func main() {
        // create url request from request protocol
        let urlRequest = createUrlRequest(from: request)
        // create the data task
        task = urlSession?.dataTask(for: urlRequest) { [weak self] (result) in
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
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
    
    // MARK: - Transformation methods
    
    func createUrlRequest(from request: Request) -> URLRequest {
        return URLRequest(request)
    }
    
}
