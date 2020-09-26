//
//  RequestComponents.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

struct RequestComponents {

    // MARK: - Properties

    /**
     The url containing the basic information for creating the Request.

     It defines:
     * protocol (e.g. HTTP or HTTPS)
     * host (e.g. "www.example.com")
     * port (e.g. "www.example.com:8080")
     * base path (e.g. "www.example.com:8080/v2/")
     */
    var url: URL
    /**
     The path in which the resource lies (e.g "www.example.com/login").
     */
    var path: String
    /**
     The HTTP method for the request (e.g GET, POST, and so on).

     The default value is GET.
     */
    var method: HTTPMethod

    // MARK: - Optional properties

    /**
     The data sent as the message body of a request, such as for an HTTP POST request.
     */
    var body: Body?
    /**
     The time in seconds that need to pass before assuming the request timed out.

     The default value is nil.
     */
    var timeoutInterval: TimeInterval?
    /**
     The HTTP headers and value for the request (e.g. Accept: application/json).

     The default value is an empty dictionary.
     */
    var headers: [String: String] = [:]
    /**
     The items that will be added to the URL as query params.

     The default value is an empty array.
     */
    var queryItems: [URLQueryItem] = []
    /**
     Options that hint on how the request should be prepared.
     */
    var options: RequestOptions = []

    // MARK: - Methods

    /**
     Transforms the `RequestComponents` into native `URLRequest`.
     */
    func toURLRequest() throws -> URLRequest {
        try URLRequestBuilder.urlRequest(from: self)
    }

}

extension RequestComponents {
    
    enum Body {
        
        /// The data to send in the request
        case data(Data)
        /// The filename that contains the body
        case dataFromFile(String, Bundle)
        /// The url that contains the body to use as body
        case dataFromFileURL(URL)
        /// The closure that returns data to use as body
        case dataFromClosure(@autoclosure () throws -> Data)
        
    }
    
}
