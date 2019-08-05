//
//  NetworkOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

class RequestOperation<Request: LeanNetworkKit.Request>: AsyncOperation, ProgressOperation {
    
    // MARK: - Properties
    
    private weak var urlSession: URLSession?
    
    private let request: Request
    private let completion: (Result<Request.Response, Error>) -> Void
    var onProgress: ((Double) -> Void)?
    
    private var task: URLSessionDataTask?
    private var token: NSKeyValueObservation?
    
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
        // add progress observation
        token = task?.addProgressObservation(onProgress)
        // start the data task
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel() // stop task
        token = nil // stop observing
    }
    
    // MARK: - Helper methods
    
    func createUrlRequest(from request: Request) -> URLRequest {
        return URLRequest(request)
    }
    
}
