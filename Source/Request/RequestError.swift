//
//  RequestError.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

public enum RequestError: LocalizedError {
    
    // URL creation error
    case malformedUrl(String)
    
    // URLRequest loading errors
    case notAnHTTPRequest
    case statusCodeError(Int)
    
    // Encoding & Decoding errors
    case failedToEncode(String)
    case failedToDecode(String)
    
    public var errorDescription: String? {
        let prefix = "Network Error - "
        switch self {
        case .malformedUrl(let urlString):
            return prefix + "Malformd url: \(urlString)"
        case .notAnHTTPRequest:
            return prefix + "Not a valid HTTP request"
        case .statusCodeError(let code):
            return prefix + "Received status code: \(code)"
        case .failedToEncode(let type):
            return prefix + "Failed to encode \(type)"
        case .failedToDecode(let type):
            return prefix + "Failed to encode \(type)"
        }
    }
    
}

public extension RequestError {
    
    static func failedToEncode<T>(type: T.Type) -> RequestError {
        return .failedToEncode("\(type.self)")
    }
    
    static func failedToDecode<T>(type: T.Type) -> RequestError {
        return .failedToDecode("\(type.self)")
    }
    
}
