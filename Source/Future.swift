//
//  Future.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 1/13/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public final class Future<Value> {
    
    // MARK: - Properties
    
    var result: Result<Value>? {
        didSet { result.map(notify(with:)) }
    }
    
    private var onSuccess: ((Value) throws -> Void)?
    private var onFailure: ((Error) -> Void)?
    
    // MARK: - Observer methods
    
    @discardableResult
    public func onSuccess(_ completion: @escaping (Value) throws -> Void) -> Future<Value> {
        onSuccess = completion
        do {
            try result?.value.map(completion)
        } catch let error {
            onFailure?(error)
        }
        return self
    }
    
    @discardableResult
    public func onFailure(_ completion: @escaping (Error) -> Void) -> Future<Value> {
        onFailure = completion
        result?.error.map(completion)
        return self
    }
    
    private func notify(with result: Result<Value>) {
        do {
            try onSuccess?(try result.resolve())
        } catch let error {
            onFailure?(error)
        }
    }
    
}
