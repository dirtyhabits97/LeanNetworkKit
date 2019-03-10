//
//  Result.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public enum Result<Value> {
    
    case success(Value)
    case failure(Error)
    
}

public extension Result {
    
    var value: Value? {
        switch self {
        case .success(let v): return v
        case .failure: return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let e): return e
        }
    }
    
    func resolve() throws -> Value {
        switch self {
        case .success(let v): return v
        case .failure(let e): throw e
        }
    }
    
}
