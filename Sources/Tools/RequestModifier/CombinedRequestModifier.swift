//
//  CombinedRequestModifier.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 A `RequestModifier` that contains other `RequestModifier`
 and executes their methods in the order of insertion.
 */
public struct CombinedRequestModifier: RequestModifier {

    // MARK: - Properties

    private let combined: [RequestModifier]

    // MARK: - Lifecycle

    /**
     - Parameters:
        - combined: the group of modifiers to relay the calls to.
     */
    public init(combined: [RequestModifier]) {
        self.combined = combined
    }

    // MARK: - Modifier methods

    public func modify(_ request: inout URLRequest) {
        for modifier in combined {
            modifier.modify(&request)
        }
    }

}
