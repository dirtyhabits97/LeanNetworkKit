//
//  NotEmptyResponse.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/// Indicates the request expects data in the response's payload.
public struct NotEmptyResponse { }

public extension Request {

    /**
    Sets the response type to NotEmptyResponse.

    It expects the response to not be empty (at least 1 byte).

    - Parameters:
       - type: NotEmptyResponse.Type
    */
    @discardableResult
    func decode(to type: NotEmptyResponse.Type) -> DecodableRequest<NotEmptyResponse> {
        return DecodableRequest(components: components) { (data, _) in
            if data.isEmpty {
                throw NKError.requestCompletion(.decoding(NotEmptyResponse.self))
            }
            return NotEmptyResponse()
        }
    }

}
