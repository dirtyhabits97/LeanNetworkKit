//
//  Future.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 1/13/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public struct Future<Value> {
    
    // MARK: - Properties
    
    private var onResult: ((Result<Value>) -> Void)?
    private var onSuccess: ((Value) -> Void)?
    private var onFailure: ((Error) -> Void)?
    
    // MARK: - Observer methods
    
    public mutating func onResult(queue: DispatchQueue? = nil,  _ completion: @escaping (Result<Value>) -> Void) {
        if let queue = queue {
            onResult = { result in queue.async { completion(result) } }
        } else {
            onResult = completion
        }
    }
    
    public mutating func onSuccess(queue: DispatchQueue? = nil, _ completion: @escaping (Value) -> Void) {
        if let queue = queue {
            onSuccess = { value in queue.async { completion(value) } }
        } else {
            onSuccess = completion
        }
    }
    
    public mutating func onFailure(queue: DispatchQueue? = nil, _ completion: @escaping (Error) -> Void) {
        if let queue = queue {
            onFailure = { error in queue.async { completion(error) } }
        } else {
            onFailure = completion
        }
    }
    
    func notify(with result: Result<Value>) {
        onResult?(result)
        do {
            onSuccess?(try result.resolve())
        } catch let error {
            onFailure?(error)
        }
    }
    
}
