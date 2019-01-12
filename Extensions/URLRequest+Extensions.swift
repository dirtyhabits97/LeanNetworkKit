//
//  URLRequest+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPMethod: String {
    
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
    
}

extension URLRequest {
    
    init(url: URL, method: HTTPMethod, headers: HTTPHeaders) {
        self.init(url: url)
        httpMethod = method.rawValue
        for header in headers {
            setValue(header.key, forHTTPHeaderField: header.value)
        }
    }
    
}
