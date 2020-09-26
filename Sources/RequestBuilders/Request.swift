//
//  Request.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 A request that expects `Data` from the server's response.
 */
public class Request: RequestBuilder {

    // MARK: - Methods

    /**
     Sets the expected type of the response.

     - Parameters:
        - type: the type to expect from the server response.
     */
    @discardableResult
    public func decode<T: Decodable>(to type: T.Type) -> DecodableRequest<T> {
        return DecodableRequest(components: components) { (data, _) in
            try JSONDecoder().decode(T.self, from: data)
        }
    }

    /**
     Defines how the server response will be decoded into a strongly typed response.

     - Parameters:
        - decode: closure that transform the server response's payload (data)
                    and statuscode into a strongly typed response.
     */
    @discardableResult
    public func decode<T>(_ decode: @escaping (Data, StatusCode) throws -> T) -> DecodableRequest<T> {
        return DecodableRequest(components: components, decode: decode)
    }

}
