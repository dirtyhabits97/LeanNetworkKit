//
//  NetworkRequestManager.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public protocol NetworkRequestManager: AnyObject {
    
    var urlSession: URLSession! { get }
    var queue: OperationQueue { get }
    
}

public extension NetworkRequestManager {
    
    func load<AnyRequest: Request>(
        _ request: AnyRequest,
        _ completion: @escaping (Result<AnyRequest.Response, Error>) -> Void
    ) {
        queue.addOperation(operation(
            request: request,
            completion
        ))
    }
    
    func load<AnyEncodableRequest: EncodableRequest>(
        _ request: AnyEncodableRequest,
        _ completion: @escaping (Result<AnyEncodableRequest.Response, Error>) -> Void
    ) {
        queue.addOperation(operation(
            request: request,
            completion
        ))
    }
    
    func operation<AnyRequest: Request>(
        request: AnyRequest,
        _ completion: @escaping (Result<AnyRequest.Response, Error>) -> Void
    ) -> Operation {
        return RequestOperation(
            urlSession: urlSession,
            request: request,
            completion
        )
    }
    
    func operation<AnyEncodableRequest: EncodableRequest>(
        request: AnyEncodableRequest,
        _ completion: @escaping (Result<AnyEncodableRequest.Response, Error>) -> Void
    ) -> Operation {
        return EncodableRequestOperation(
            urlSession: urlSession,
            request: request,
            completion
        )
    }
    
}
