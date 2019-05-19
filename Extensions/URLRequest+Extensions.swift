//
//  URLRequest+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension URLRequest {
    
    init<AnyRequest: Request>(
        request: AnyRequest
    ) throws {
        self.init(url: try URL(request: request))
        httpMethod = request.method.rawValue
        set(headers: request.headers ?? [:])
    }
    
    init<AnyEncodableRequest: EncodableRequest>(
        encodableRequest request: AnyEncodableRequest
    ) throws {
        self.init(url: try URL(request: request))
        httpMethod = request.method.rawValue
        httpBody = try request.encode(request.body)
        set(headers: request.headers ?? [:])
    }
    
    private mutating func set(headers: HTTPHeaders) {
        for (header, value) in headers {
            setValue(value, forHTTPHeaderField: header)
        }
    }
    
}
