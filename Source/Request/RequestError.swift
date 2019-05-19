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
    case noInternet
    case notAnHTTPRequest
    case statusCodeError(Int)
    case nilData
    
    // Encoding & Decoding errors
    case failedToEncode(String)
    case failedToDecode(String)
    
    public var errorDescription: String? {
        switch self {
        case .malformedUrl(let urlString):
            return "Malformd url: \(urlString)"
        case .noInternet:
            return "Device is not connected to Internet"
        case .notAnHTTPRequest:
            return "Not a valid HTTP request"
        case .statusCodeError(let code):
            return "Received status code: \(code)"
        case .nilData:
            return "Received nil data after all validations passed"
        case .failedToEncode(let type):
            return "Failed to encode \(type)"
        case .failedToDecode(let type):
            return "Failed to encode \(type)"
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
