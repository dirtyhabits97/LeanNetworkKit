//
//  Request.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

public typealias HTTPHeaders = [String: String]

public protocol Request {
    
    associatedtype Response
    
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var queryItems: [URLQueryItem]? { get }
    
    var decode: (Data) throws -> Response { get }
    
}

public extension Request {
    
    var method: HTTPMethod { return .GET }
    var headers: HTTPHeaders { return [:] }
    var queryItems: [URLQueryItem]? { return nil }
    
}

public extension Request where Response: Decodable {
    
    var decode: (Data) throws -> Response {
        return { data in try data.jsonDecoded() }
    }
    
}

public struct IgnoreResponse { }
public struct EmptyResponse { }

public extension Request where Response == IgnoreResponse {
    
    var decode: (Data) throws -> Response {
        return { _ in IgnoreResponse() }
    }
    
}

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
