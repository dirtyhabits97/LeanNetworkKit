//
//  RequestBuilder.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 Entity that builds the necessary components for any type of request.
 */
public class RequestBuilder {

    // MARK: - Properties

    /// The components that helps build the `URLRequest`.
    var components: RequestComponents

    // MARK: - Lifecycle

    init(components: RequestComponents) {
        self.components = components
    }

    /**
     - Parameters:
        - url: url to call during the request.
        - path: path that is appended to the url. default value `""`.
        - method: `HTTPMethod` of the request. default value `get`.
     */
    public init(
        url: URL,
        path: String = "",
        method: HTTPMethod = .get
    ) {
        self.components = RequestComponents(url: url, path: path, method: method)
    }

    // MARK: - Methods
    
    /**
     - Parameters:
        - data: the data to send as body of the request.
     */
    @discardableResult
    public func setBody(_ data: Data) -> Self {
        components.body = .data(data)
        return self
    }
    
    /**
     - Parameters:
        - filename: the name of the file that contains the request's
                    data.
        - bundle: the bundle that contains the file.
     */
    @discardableResult
    public func setBody(
        fromFile filename: String,
        in bundle: Bundle = .main
    ) -> Self {
        components.body = .dataFromFile(filename, bundle)
        return self
    }
    
    /**
     - Parameters:
        - url: the url where the file is located.
     */
    @discardableResult
    public func setBody(fromFileAt url: URL) -> Self {
        components.body = .dataFromFileURL(url)
        return self
    }
    
    /**
     - Parameters:
        - data: the closure that generates data.
    */
    @discardableResult
    public func setBody(_ data: @escaping () throws -> Data) -> Self {
        components.body = .dataFromClosure(try data())
        return self
    }
    
    /**
     - Parameters:
        - object: the encodable object to encode as body of the request.
    */
    @discardableResult
    public func setBody<Object: Encodable>(fromObject object: Object) -> Self {
        components.body = .dataFromClosure(try JSONEncoder().encode(object))
        return self
    }

    /**
     - Parameters:
        - timeoutInterval: the time in seconds that need to pass before assuming the request timed out.
     */
    @discardableResult
    public func setTimeout(_ timeoutInterval: TimeInterval) -> Self {
        components.timeoutInterval = timeoutInterval
        return self
    }

    /**
     - Parameters:
        - key: the key of the header.
        - val: the value of the header.
     */
    @discardableResult
    public func addHeader(key: String, val: String) -> Self {
        components.headers[key] = val
        return self
    }

    /**
    - Parameters:
       - key: the name of the query item to append to the path.
       - val: the value of the query item. The default value is nil.
    */
    @discardableResult
    public func addQueryItem(key: String, val: String? = nil) -> Self {
        components.queryItems.append(URLQueryItem(name: key, value: val))
        return self
    }

    /**
    - Parameters:
       - option: the options that hint on how the request should be prepared.
    */
    @discardableResult
    public func addOption(_ option: RequestOptions) -> Self {
        components.options = components.options.union(option)
        return self
    }

    // MARK: - Proxy methods

    func build() throws -> URLRequest {
        try components.toURLRequest()
    }

}
