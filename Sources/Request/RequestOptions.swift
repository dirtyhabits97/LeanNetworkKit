//
//  RequestOptions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public struct RequestOptions: OptionSet {

    // MARK: - Options
    
    /**
     The request's original URL should not be altered during
     the request's creation.
     */
    public static let enforceURL = RequestOptions(rawValue: 1 << 0)

    // MARK: - Properties

    public let rawValue: Int

    // MARK: - Lifecycle

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

}
