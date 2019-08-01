//
//  Result+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 7/31/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

extension Result where Failure == Error {
    
    func map<NewSuccess>(
        _ transform: (Success) throws -> NewSuccess
    ) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value): return .init { try transform(value) }
        case .failure(let error): return .failure(error)
        }
    }
    
}
