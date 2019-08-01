//
//  URLRequest+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension URLRequest {
    
    init(_ request: BaseRequest) {
        self.init(url: URL(request))
        httpMethod = request.method.rawValue
        for (header, value) in (request.headers ?? [:]) {
            setValue(value, forHTTPHeaderField: header)
        }
    }
    
    init<R: EncodableRequest>(encodableRequest request: R) {
        do {
            self.init(request)
            httpBody = try request.encode(request.body)
        } catch let error {
            fatalError("Networking - Failed to encode body: \(error.localizedDescription)")
        }
    }
    
}
