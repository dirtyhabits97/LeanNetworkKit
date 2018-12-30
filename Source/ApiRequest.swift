//
//  ApiRequest.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public final class ApiRequest<Resource: ApiResource> {
    
    let resource: Resource
    
    public init(resource: Resource) {
        self.resource = resource
    }
    
}

extension ApiRequest: NetworkRequest {
    
    public func load(then completion: @escaping (Result<Resource.Model>) -> Void) {
        load(resource.urlRequest, withCompletion: completion)
    }
    
    func decode(_ data: Data) -> Result<Resource.Model> {
        return resource.makeModel(data: data)
    }
    
}
