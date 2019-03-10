//
//  ApiRequest.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public final class ApiRequest<Resource: ApiResource> {
    
    // MARK: - Properties
    
    private let resource: Resource
    let urlSession: URLSession?
    
    // MARK: - Initializer
    
    public init(resource: Resource, urlSession: URLSession? = nil) {
        self.resource = resource
        self.urlSession = urlSession
    }
    
}

extension ApiRequest: NetworkRequest {
    
    public func load(_ completion: @escaping (Result<Resource.Model>) -> Void) {
        return loadModel(urlRequest: resource.urlRequest, then: completion)
    }
    
    func decode(_ data: Data) -> Result<Resource.Model> {
        return resource.model(from: data)
    }
    
}
