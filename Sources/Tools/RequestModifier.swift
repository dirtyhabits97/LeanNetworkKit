//
//  RequestModifier.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 The `RequestModifier` is an entity that modifies the request
 before it starts.
 */
public protocol RequestModifier {

    /**
     Modifies the request.

     - Parameters:
        - request: the `URLRequest` that will be sent.
     */
    func modify(_ request: inout URLRequest)

}
