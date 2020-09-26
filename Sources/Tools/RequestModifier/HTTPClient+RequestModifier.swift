//
//  HTTPClient+RequestModifier.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public extension HTTPClient {

    /**
     - Parameters:
        - modifier: the entity that modifies the request before it starts.
     */
    @discardableResult
    func setModifier(_ modifier: @autoclosure () -> RequestModifier) -> Self {
        requestModifier = modifier()
        return self
    }

    /**
     - Parameters:
        - modify: the closure to call to modify the request before it starts.
     */
    @discardableResult
    func modifyRequests(_ modify: @escaping (inout URLRequest) -> Void) -> Self {
        // create modifier
        let modifier = ClosureRequestModifier(modifyClosure: modify)
        // check if a modifier already exists
        if let requestModifier = self.requestModifier {
            self.requestModifier = CombinedRequestModifier(combined: [
                // old modifier
                requestModifier,
                // new modifier,
                modifier
            ])
        // if it doesn't exist, directly set the modifier
        } else {
            self.requestModifier = modifier
        }
        return self
    }

}
