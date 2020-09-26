//
//  HTTPClient+Combine.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation
#if canImport(Combine)
import Combine
#endif

@available(iOS 13.0, *)
public extension HTTPClient {

    /**
     Returns a publisher that wraps the request's scheduling and execution.

     The publisher publishes data when the request's execution is over, or terminates if it fails with an error.

     - Parameters:
        - request: the request to schedule
     */
    func publisher<Response>(
        for request: DecodableRequest<Response>
    ) -> AnyPublisher<Response, NKError.RequestError> {
        // create a Future publisher
        Combine.Future<Response, NKError.RequestError> { completion in
            // schedule the given request
            self.send(request, completion)
        }
        // type erase
        .eraseToAnyPublisher()
    }

}
