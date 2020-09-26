//
//  ClosureRequestModifier.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 A `RequestModifier` with injectable behavior.
 */
struct ClosureRequestModifier: RequestModifier {

    // MARK: - Properties

    let modifyClosure: (inout URLRequest) -> Void

    // MARK: - Modifier methods

    func modify(_ request: inout URLRequest) {
        modifyClosure(&request)
    }

}
