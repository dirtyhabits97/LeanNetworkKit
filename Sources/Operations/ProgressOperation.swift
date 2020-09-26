//
//  ProgressOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 8/5/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

public protocol ProgressOperation: Operation {
    
    var onProgress: ((Double) -> Void)? { get set }
    
}
