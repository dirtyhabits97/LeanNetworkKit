//
//  EmptyResponse.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/// Indicates the request expects 0bytes in the response's payload.
public struct EmptyResponse { }

public extension Request {

    /**
     Sets the response type to EmptyResponse.

     It expects the response to be empty (0 bytes)

     - Parameters:
        - type: EmptyResponse.Type
     */
    @discardableResult
    func decode(to type: EmptyResponse.Type) -> DecodableRequest<EmptyResponse> {
        return DecodableRequest(components: components) { (data, statusCode) in
            guard statusCode == 204 && data.isEmpty else {
                throw NKError.requestCompletion(.decoding(EmptyResponse.self))
            }
            return EmptyResponse()
        }
    }

}
