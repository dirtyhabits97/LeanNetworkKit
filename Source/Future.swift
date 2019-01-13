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
    
    public mutating func onResult(_ completion: @escaping (Result<Value>) -> Void) {
        onResult = completion
    }
    
    public mutating func onSuccess(_ completion: @escaping (Value) -> Void) {
        onSuccess = completion
    }
    
    public mutating func onFailure(_ completion: @escaping (Error) -> Void) {
        onFailure = completion
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
