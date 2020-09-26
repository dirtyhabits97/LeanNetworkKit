//
//  URLRequestBuilder.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/3/19.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 Helper that builds an `URLRequest` based on `RequestComponents`.
 */
enum URLRequestBuilder {

    /// The set of characters that do not need to be encoded in the path.
    private static let pathAllowedChars = CharacterSet.urlPathAllowed.union(.urlQueryAllowed)

    /**
    Creates an `URL` based on a `RequestComponents`.

    - Parameters:
       - request: the `RequestComponents` that contains the elements of the `URL`.

     - Returns:
        A valid `URL`.
    */
    static func url(from request: RequestComponents) throws -> URL {
        // attempt to encode the path
        guard let encodedPath = request.path.addingPercentEncoding(withAllowedCharacters: pathAllowedChars) else {
            throw NKError.requestCreation(.pathEncoding(request.path))
        }
        // create the raw url with the encoded path
        let raw = request.url.absoluteString + encodedPath
        // valiate the new url is formatted
        guard let url = URL(string: raw) else {
            throw NKError.requestCreation(.malformedURL(raw))
        }
        // check if the request has specified query items
        guard !request.queryItems.isEmpty else {
            // if not, return the url
            return url
        }
        // attempt to transform the URL into URLComponents to inject the remaining properties
        // in theory, this should not fail if the url is valid.
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NKError.requestCreation(.malformedURL(url.absoluteString))
        }
        // set the query items
        components.queryItems = request.queryItems
        // obtain the formatted url
        guard let formattedUrl = components.url else {
            throw NKError.requestCreation(.malformedURL(components.string ?? ""))
        }
        // return the formatted url
        return formattedUrl
    }

    /**
     Creates an `URLRequest` based on `RequestComponents`.

     - Parameters:
        - components: the `RequestComponents` that contains the elements of the `URLRequest`.

     - Returns:
        A valid `URLRequest`.
     */
    static func urlRequest(from request: RequestComponents) throws -> URLRequest {
        // attempt to create the url from the request
        let url = try URLRequestBuilder.url(from: request)
        // create the url request
        var urlRequest = URLRequest(url: url)
        // set the method
        urlRequest.httpMethod = request.method.rawValue
        // set the body
        switch request.body {
        case let .data(data):
            urlRequest.httpBody = data
        case let .dataFromFile(filename, bundle):
            urlRequest.httpBody = try bundle.data(from: filename)
        case let .dataFromFileURL(url):
            urlRequest.httpBody = try Data(contentsOf: url)
        case let .dataFromClosure(data):
            urlRequest.httpBody = try data()
        default:
            urlRequest.httpBody = nil
        }
        // set the timeout
        if let timeoutInterval = request.timeoutInterval {
            urlRequest.timeoutInterval = timeoutInterval
        }
        // set the headers
        for (header, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        // return the formatted url request
        return urlRequest
    }

}
