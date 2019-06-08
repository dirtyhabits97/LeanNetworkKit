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
        // append the path
        let urlString = request.baseUrl.absoluteString + request.path
        // check if url is valid
        guard let url = URL(string: urlString) else {
            throw RequestError.malformedUrl(urlString)
        }
        // check for query params
        guard let queryItems = request.queryItems else {
            self = url
            return
        }
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )!
        // append query items
        components.queryItems = queryItems + (components.queryItems ?? [])
        // get the formatted url
        guard let formattedUrl = components.url else {
            let string = urlString + (components.percentEncodedQuery ?? "")
            throw RequestError.malformedUrl(string)
        }
        self = formattedUrl
    }
    
}
