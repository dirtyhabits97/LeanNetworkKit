//
//  URL+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension URL {
    
    init(_ request: BaseRequest) {
        // create the raw url
        let raw = request.baseUrl.absoluteString + request.path
        // check if url is valid
        guard var components = URLComponents(string: raw) else {
            fatalError("Networking - Malformed url: \(raw)")
        }
        // check for query params
        if let queryItems = request.queryItems {
            components.queryItems = queryItems
        }
        // get formatted url
        guard let url = components.url else {
            fatalError("Networking - Malformed url: \(components.string ?? raw)")
        }
        self = url
    }
    
}
