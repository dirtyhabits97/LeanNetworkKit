//
//  ApiResource.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

enum ApiResourceError: LocalizedError {
    
    case failedToDecode
    
    var errorDescription: String? {
        switch self {
        case .failedToDecode: return "Failed to decode JSON to Model"
        }
    }
    
}

public protocol ApiResource {
    
    associatedtype Model: Decodable
    
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    
}

extension ApiResource {
    
    public var method: HTTPMethod { return .GET }
    public var headers: HTTPHeaders? { return nil }
    public var queryItems: [URLQueryItem]? { return nil }
    public var absoluteUrlString: String { return url.absoluteString }
    
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

extension ApiResource where Model == Data {
    
    func model(from data: Data) -> Result<Model> {
        print("Model is data")
        print("Data: \(data)")
        return .success(data)
    }
    
}

extension ApiResource {
    
    func model(from data: Data) -> Result<Model> {
        print("Model is not Data")
        print(type(of: Model.self))
        if let model: Model = try? data.jsonDecoded() {
            return .success(model)
        }
        return .failure(ApiResourceError.failedToDecode)
    }
    
}

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
