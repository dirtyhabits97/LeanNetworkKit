//
//  ApiResource.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

// MARK: - Error

enum ApiResourceError: LocalizedError {
    
    case failedToDecode
    
    var errorDescription: String? {
        switch self {
        case .failedToDecode: return "Failed to decode JSON to Model"
        }
    }
    
}

// MARK: - ApiResource Base

public protocol ApiResource {
    
    associatedtype Model: Decodable
    
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    
    func model(from data: Data) -> Result<Model>
    
}

public extension ApiResource {
    
    var method: HTTPMethod { return .GET }
    var headers: HTTPHeaders? { return nil }
    var queryItems: [URLQueryItem]? { return nil }
    var absoluteUrlString: String { return url.absoluteString }
    
    func model(from data: Data) -> Result<Model> {
        if Model.self == Data.self {
            return .success(data as! Model)
        } else if let model: Model = try? data.jsonDecoded() {
            return .success(model)
        }
        return .failure(ApiResourceError.failedToDecode)
    }
    
}

extension ApiResource {
    
    var url: URL {
        let raw = baseUrl.absoluteString + path
        var components = URLComponents(string: raw)!
        components.queryItems = queryItems
        return components.url!
    }
    
    var urlRequest: URLRequest {
        return .init(url: url, method: method, headers: headers ?? [:])
    }
    
}

// MARK: - ApiResource Encodable

public protocol ApiResourceEncodable: ApiResource {
    
    associatedtype Body: Encodable
    var body: Body { get }
    
}

extension ApiResourceEncodable {
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: url, method: method, headers: headers ?? [:])
        request.httpBody = try? body.jsonEncoded()
        return request
    }
    
}
