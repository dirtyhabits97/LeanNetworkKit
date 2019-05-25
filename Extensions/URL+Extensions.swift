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
        let urlString = request.baseUrl.absoluteString + request.path
        guard let url = URL(string: urlString) else {
            throw RequestError.malformedUrl(urlString)
        }
        guard let queryItems = request.queryItems else {
            self = url
            return
        }
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )!
        components.queryItems = queryItems
        guard let absoluteUrl = components.url else {
            let string = urlString + (components.percentEncodedQuery ?? "")
            throw RequestError.malformedUrl(string)
        }
        self = absoluteUrl
    }
    
}
