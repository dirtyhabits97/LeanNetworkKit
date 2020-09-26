//
//  IgnoreResponse.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/// Indicates the request will not decode the response's payload.
public struct IgnoreResponse { }

public extension Request {

    /**
     Sets the response type to IgnoreResponse.

     It ignores the received data / payload from the server.
     */
    @discardableResult
    func ignoreResponse() -> DecodableRequest<IgnoreResponse> {
        return DecodableRequest(components: components) { (_, _) in
            IgnoreResponse()
        }
    }

}
