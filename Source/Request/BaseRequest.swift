//
//  BaseRequest.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 7/31/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

public typealias HTTPHeaders = [String: String]

public protocol BaseRequest {
    
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    
}

public extension BaseRequest {
    
    var method: HTTPMethod { return .get }
    var headers: HTTPHeaders? { return nil }
    var queryItems: [URLQueryItem]? { return nil }
    
}
