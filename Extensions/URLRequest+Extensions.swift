//
//  URLRequest+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension URLRequest {
    
    typealias Headers = [String: String]
    
    init(url: URL, httpMethod: String, headers: Headers?) {
        self.init(url: url)
        self.httpMethod = httpMethod
        for header in headers ?? [:] {
            setValue(header.key, forHTTPHeaderField: header.value)
        }
    }
    
}
