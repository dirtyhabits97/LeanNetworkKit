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
    
    var result: Result<Value>? {
        didSet { result.map(notify(with:)) }
    }
    
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
        if let result = self.result { onResult?(result)  }
    }
    
    public mutating func onSuccess(queue: DispatchQueue? = nil, _ completion: @escaping (Value) -> Void) {
        if let queue = queue {
            onSuccess = { value in queue.async { completion(value) } }
        } else {
            onSuccess = completion
        }
        if let value = self.result?.value { onSuccess?(value)  }
    }
    
    public mutating func onFailure(queue: DispatchQueue? = nil, _ completion: @escaping (Error) -> Void) {
        if let queue = queue {
            onFailure = { error in queue.async { completion(error) } }
        } else {
            onFailure = completion
        }
        if let error = self.result?.error { onFailure?(error)  }
    }
    
    private func notify(with result: Result<Value>) {
        onResult?(result)
        do {
            onSuccess?(try result.resolve())
        } catch let error {
            onFailure?(error)
        }
    }
    
}
