//
//  DecodableRequest.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

/**
 A request that expects a `Data` from the server's response.
 But also requires that the `Data` can be parsed to a strongly-typed
 response.
 */
public class DecodableRequest<T>: Request {

    // MARK: - Properties

    /**
     The closure that defines how the data will be converted to a
     strongly typed response.
    */
    let internalDecode: (Data, StatusCode) throws -> T

    // MARK: - Lifecycle

    init(
        components: RequestComponents,
        decode: @escaping (Data, StatusCode) throws -> T
    ) {
        self.internalDecode = decode
        super.init(components: components)
    }

}
