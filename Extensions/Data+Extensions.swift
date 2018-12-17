//
//  Data+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension Data {
    
    public func jsonDecode<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
    
}

extension Encodable {
    
    public var jsonEncoded: Data? {
        return try? jsonEncode()
    }
    
    public func jsonEncode() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
}
