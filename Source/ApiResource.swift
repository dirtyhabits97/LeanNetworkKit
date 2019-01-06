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
    
    typealias Headers = [String: String]
    
    var urlString: String { get }
    var httpMethod: String { get }
    
    var headers: Headers? { get }
    
}

extension ApiResource {
    
    public var headers: Headers? { return nil }
    var url: URL { return URL(string: urlString)! }
    var urlRequest: URLRequest { return URLRequest(url: url, httpMethod: httpMethod, headers: headers) }
    
    func makeModel(data: Data) -> Result<Model> {
        if let model: Model = try? data.jsonDecode() {
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
        var urlRequest = URLRequest(url: url, httpMethod: httpMethod, headers: headers)
        urlRequest.httpBody = body.jsonEncoded
        return urlRequest
    }
    
}
