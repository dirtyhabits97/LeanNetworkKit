//
//  HTTPClient.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

// TODO: document this
public class HTTPClient {
    
    // TODO: document this
    public let queue: OperationQueue
    // TODO: document this
    public let urlSession: URLSession
    /// The `URL` to use before sending the requests.
    var baseUrl: URL?
    /// Observes the requests.
    var requestObserver: RequestObserver?
    /// Modifies the requests.
    var requestModifier: RequestModifier?
    
    public init(urlSession: URLSession) {
        self.queue = OperationQueue()
        self.urlSession = urlSession
    }
    
}

public extension HTTPClient {
    
    // TODO: document this
    private func operation<Response>(
        for request: DecodableRequest<Response>,
        _ completion: @escaping (Result<Response, NKError.RequestError>) -> Void
    ) -> Operation {
        let operation = RequestOperation(
            urlSession: urlSession,
            request: request,
            completion
        )
        operation.baseURL = baseUrl
        operation.modifier = requestModifier
        operation.observer = requestObserver
        return operation
    }
    
    // TODO: document this
    func send<Response>(
        _ request: DecodableRequest<Response>,
        _ completion: @escaping (Result<Response, NKError.RequestError>) -> Void
    ) {
        queue.addOperation(self.operation(
            for: request,
            completion
        ))
    }
    
    // TODO: document this
    func send<Response>(_ request: DecodableRequest<Response>) -> Future<Response, NKError.RequestError> {
        Future { completion in
            send(request, completion)
        }
    }
    
}
