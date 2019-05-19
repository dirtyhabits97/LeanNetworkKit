//
//  URL+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension URL {
    
    init<AnyRequest: Request>(
        request: AnyRequest
    ) throws {
        let url = request.baseUrl.appendingPathComponent(request.path)
        // check if query items
        guard let queryItems = request.queryItems else {
            self = url
            return
        }
        var urlComponents = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )!
        urlComponents.queryItems = queryItems
        guard let absoluteUrl = urlComponents.url else {
            let string = url.absoluteString + queryItems.formatted
            throw RequestError.malformedUrl(string)
        }
        self = absoluteUrl
    }
    
}

private extension Array where Element == URLQueryItem {
    
    var formatted: String {
        var strings: [String] = []
        for element in self {
            var string = element.name
            element.value.map { string.append("=\($0)") }
            strings.append(string)
        }
        return "?" + strings.joined(separator: "&")
    }
    
}
