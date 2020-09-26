//
//  AsyncOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

class AsyncOperation: Operation {
    
    // MARK: - Properties
    
    var state: State = .ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady:     Bool { return super.isReady && state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished:  Bool { return state == .finished }
    
    override var isAsynchronous: Bool { return true }
    
    // MARK: - Lifecycle
    
    override func start() {
        guard !isCancelled && !isFinished else {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        state = .finished
    }
    
}

extension AsyncOperation {
    
    enum State: String {
        
        case ready
        case executing
        case finished
        
        fileprivate var keyPath: String {
            return "is\(rawValue.capitalized)"
        }
        
    }
    
}
