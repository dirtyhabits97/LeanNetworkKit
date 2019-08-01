//
//  EncodableRequest.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

public protocol EncodableRequest: Request {
    
    associatedtype Body
    
    var body: Body { get }
    var encode: (Body) throws -> Data { get }
    
}

public extension EncodableRequest {
    
    var method: HTTPMethod { return .post }
    
}

public extension EncodableRequest where Body: Encodable {
    
    var encode: (Body) throws -> Data {
        return { body in try body.jsonEncoded() }
    }
    
}
