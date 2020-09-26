//
//  RequestObserver.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 The `RequestObserver` is an entity that observes the request
 lifecycle.

 It gets notified when:
 * The request starts
 * The request succeeds
 * The request fails
 * The request is canceled

 */
public protocol RequestObserver {

    /**
     Called before starting the request.

     - Parameters:
        - request: the `URLRequest` to send.
     */
    func requestWillLoad(_ request: URLRequest)

    /**
     Called after the server responded.

     If a generic or local error happened, this method
     is not called.

     - Parameters:
        - request: the `URLRequest` that was sent.
        - response: the `HTTPURLResponse` from the server.
        - rawValue: the server output. `Data` if it was a data request.
     */
    func requestDidLoad(
        _ request: URLRequest,
        response: HTTPURLResponse,
        rawValue: Data?
    )

    /**
     Called after the request succeeded.

     - Parameters:
        - request: the `URLRequest` that succeeded.
        - value: the value created from the server response and payload.
     */
    func requestDidSucceed(
        _ request: URLRequest,
        value: Any
    )
    /**
     Called after the request failed.

     - Parameters:
        - request: the `URLRequest` that failed.
        - error: the reason of the failure.
     */
    func requestDidFail(
        _ request: URLRequest,
        error: NKError.RequestError
    )

    /**
     Called after the request was canceled.

     - Parameters:
        - request: the `URLRequest` that failed.
     */
    func didCancelRequest(_ request: URLRequest)

}
