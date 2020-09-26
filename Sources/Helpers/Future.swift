//
//  Future.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/3/19.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 A wrapper that eventually will succeed or fail.
 */
public final class Future<Value, Error: Swift.Error> {

    // MARK: - Properties

    /// Saved result, in case the closures were not set when it was resolved
    var onHold: Result<Value, Error>?
    /// Closure to execute when the task succeeds.
    var onSuccess: ((Value) -> Void)?
    /// Closure to execute when the task fails.
    var onFailure: ((Error) -> Void)?

    // MARK: - Lifecycle

    public init() { }

    /**
     - Parameters:
        - completion: A closure that takes another closure of type `(Result<Value, Error>) -> Void`
                      as an input.
     */
    public init(_ completion: (@escaping (Result<Value, Error>) -> Void) -> Void) {
        completion(resolve)
    }

    // MARK: - Methods

    /**
     - Parameters:
        - onSuccess: the closure to execute when the result is resolved succesfully.
     */
    @discardableResult
    public func onSuccess(_ onSuccess: @escaping (Value) -> Void) -> Self {
        self.onSuccess = onSuccess
        // trigger the success callback if there is a result on hold
        onHold.map(resolve)
        return self
    }

    /**
     - Parameters:
        - onFailure: the closure to execute when the result is resolved with error.
     */
    @discardableResult
    public func onFailure(_ onFailure: @escaping (Error) -> Void) -> Self {
        self.onFailure = onFailure
        // trigger the failure callback if there is a result on hold
        onHold.map(resolve)
        return self
    }

    // MARK: - Helper methods

    /**
     Resolves a result. If the corresponding closure is not set, the result is on hold.

     If the result succeeds and `onSuccess` is set, `onSuccess` is triggered.
     If the result fails and `onFailure` is set, `onFailure` is triggered.
     Otherwise, the result is stored and awaits until the right callback is set.

     - Parameters:
        - result: the result to resolve.
     */
    func resolve(with result: Result<Value, Error>) {
        // clear the on hold param
        onHold = nil
        // check if the success callback is set
        if case .success(let data) = result, let onSuccess = self.onSuccess {
            onSuccess(data)
            return
        }
        // check if the failure callback is set
        if case .failure(let error) = result, let onFailure = self.onFailure {
            onFailure(error)
            return
        }
        // hold the result
        onHold = result
    }

}

