//
//  ClosureRequestObserver.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 A `RequestObserver` with injectable behavior.
 */
struct ClosureRequestObserver: RequestObserver {

    // MARK: - Properties

    let requestWillLoadClosure: ((URLRequest) -> Void)?
    let requestDidLoadClosure: ((URLRequest, HTTPURLResponse, Data?) -> Void)?
    let requestDidSucceedClosure: ((URLRequest, Any) -> Void)?
    let requestDidFailClosure: ((URLRequest, NKError.RequestError) -> Void)?
    let didCancelRequestClosure: ((URLRequest) -> Void)?

    // MARK: - Lifecycle

    init(
        requestWillLoad: ((URLRequest) -> Void)? = nil,
        requestDidLoad: ((URLRequest, HTTPURLResponse, Data?) -> Void)? = nil,
        requestDidSucceed: ((URLRequest, Any) -> Void)? = nil,
        requestDidFail: ((URLRequest, NKError.RequestError) -> Void)? = nil,
        didCancelRequest: ((URLRequest) -> Void)? = nil
    ) {
        self.requestWillLoadClosure = requestWillLoad
        self.requestDidLoadClosure = requestDidLoad
        self.requestDidSucceedClosure = requestDidSucceed
        self.requestDidFailClosure = requestDidFail
        self.didCancelRequestClosure = didCancelRequest
    }

    // MARK: - Observer methods

    func requestWillLoad(_ request: URLRequest) {
        requestWillLoadClosure?(request)
    }

    func requestDidLoad(
        _ request: URLRequest,
        response: HTTPURLResponse,
        rawValue: Data?
    ) {
        requestDidLoadClosure?(request, response, rawValue)
    }

    func requestDidSucceed(
        _ request: URLRequest,
        value: Any
    ) {
        requestDidSucceedClosure?(request, value)
    }

    func requestDidFail(
        _ request: URLRequest,
        error: NKError.RequestError
    ) {
        requestDidFailClosure?(request, error)
    }

    func didCancelRequest(_ request: URLRequest) {
        didCancelRequestClosure?(request)
    }

}

