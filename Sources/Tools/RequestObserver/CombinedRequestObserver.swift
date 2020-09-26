//
//  CombinedRequestObserver.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 A `RequestObserver` that contains other `RequestObserver`
 and executes their methods in the order of insertion.
 */
public struct CombinedRequestObserver: RequestObserver {

    // MARK: - Properties

    private let combined: [RequestObserver]

    // MARK: - Lifecycle

    /**
     - Parameters:
        - combined: the group of observers to relay the calls to.
     */
    public init(combined: [RequestObserver]) {
        self.combined = combined
    }

    // MARK: - Observer methods

    public func requestWillLoad(_ request: URLRequest) {
        for observer in combined {
            observer.requestWillLoad(request)
        }
    }

    public func requestDidLoad(
        _ request: URLRequest,
        response: HTTPURLResponse,
        rawValue: Data?
    ) {
        for observer in combined {
            observer.requestDidLoad(request, response: response, rawValue: rawValue)
        }
    }

    public func requestDidSucceed(
        _ request: URLRequest,
        value: Any
    ) {
        for observer in combined {
            observer.requestDidSucceed(request, value: value)
        }
    }

    public func requestDidFail(
        _ request: URLRequest,
        error: NKError.RequestError
    ) {
        for observer in combined {
            observer.requestDidFail(request, error: error)
        }
    }

    public func didCancelRequest(_ request: URLRequest) {
        for observer in combined {
            observer.didCancelRequest(request)
        }
    }

}

