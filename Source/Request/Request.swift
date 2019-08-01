//
//  Request.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

public protocol Request: BaseRequest {
    
    associatedtype Response
    
    var decode: (Data) throws -> Response { get }
    
}

// MARK: - Raw

public extension Request where Response == Data {
    
    var decode: (Data) throws -> Response {
        return { data in data }
    }
    
}

// MARK: - Decodable

public extension Request where Response: Decodable {
    
    var decode: (Data) throws -> Response {
        return { data in try data.jsonDecoded() }
    }
    
}

// MARK: - Ignore response

public struct IgnoreResponse { }

public extension Request where Response == IgnoreResponse {
    
    var decode: (Data) throws -> Response {
        return { _ in IgnoreResponse() }
    }
    
}

// MARK: - Empty response

public struct EmptyResponse { }

public extension Request where Response == EmptyResponse {
    
    var decode: (Data) throws -> Response {
        return { data in
            guard data.isEmpty else {
                throw RequestError.failedToDecode(type: EmptyResponse.self)
            }
            return EmptyResponse()
        }
    }
    
}
