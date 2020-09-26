//
//  HTTPClient+RequestObserver.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public extension HTTPClient {

    /**
     - Parameters:
        - observer: the entity that will observe the requests.
     */
    @discardableResult
    func setObserver(_ observer: @autoclosure () -> RequestObserver) -> Self {
        requestObserver = observer()
        return self
    }

    /**
     - Parameters:
        - requestWillLoad: called before starting the request.
        - requestDidLoad: called after the server responded.
        - requestDidSucceed: called after the request succeeded.
        - requestDidFail: called after the request failed.
        - didCancelRequest: called after the request was canceled.
     */
    @discardableResult
    func observeRequests(
        requestWillLoad: ((URLRequest) -> Void)? = nil,
        requestDidLoad: ((URLRequest, HTTPURLResponse, Data?) -> Void)? = nil,
        requestDidSucceed: ((URLRequest, Any) -> Void)? = nil,
        requestDidFail: ((URLRequest, NKError.RequestError) -> Void)? = nil,
        didCancelRequest: ((URLRequest) -> Void)? = nil
    ) -> Self {
        // create observer
        let observer = ClosureRequestObserver(
            requestWillLoad: requestWillLoad,
            requestDidLoad: requestDidLoad,
            requestDidSucceed: requestDidSucceed,
            requestDidFail: requestDidFail,
            didCancelRequest: didCancelRequest
        )
        // check if an observer already exists
        if let requestObserver = self.requestObserver {
            self.requestObserver = CombinedRequestObserver(combined: [
                // old observer
                requestObserver,
                // new closure observer
                observer
            ])
        // if it doesn't exist, directly set the observer
        } else {
            self.requestObserver = observer
        }
        return self
    }

}

