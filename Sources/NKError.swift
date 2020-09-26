//
//  NKError.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/3/19.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public enum NKError: Error {

    // MARK: - Cases

    /**
     Error during the request's creation.
     */
    case requestCreation(RequestCreationError)
    /**
     Error during the request's completion.
     */
    case requestCompletion(RequestCompletionError)

    // MARK: - Errors

    /**
     Errors during the request's creation.
     */
    public enum RequestCreationError: Error {

        /**
         Failed to encode the request's url.
         */
        case urlEncoding(String)
        /**
         Failed to encode the request's path.
         */
        case pathEncoding(String)
        /**
         The request's url is malformed.
         */
        case malformedURL(String)

    }

    /**
     Errors during the request's completion.
     */
    public enum RequestCompletionError: Error {

        /**
         Failed to get the server's `HTTPURLResponse`.
         */
        case noResponse
        /**
         Failed to get the request's value from the server's response.
         */
        case noValue
        /**
         Failed to decode the request's Response type.
         */
        case decoding(String)

        public static func decoding<T>(_ type: T.Type) -> Self {
            return .decoding(String(describing: type))
        }

    }

    /**
     Errors during the scheduling and execution of the request.
     */
    public enum RequestError: Error {
        /**
         Failed to perform the request due to a generic / system error.
         */
        case genericError(Error)
        /**
         Failed to perform the request due to a local network error.
         */
        case localError(URLError)
        /**
         Failed to perform the request due to a client-side error.

         Parameters:
         ----------------
            - **data**: the server's response's payload (raw).
            - **statusCode**: the server's response's statuscode.
         */
        case clientError(Data, StatusCode)
        /**
         Failed to perform the request due to a server-side error.

         Parameters
         ----------------
            - **statusCode**: the server's response's statuscode.
         */
        case serverError(StatusCode)

    }

}

public extension NKError.RequestError {

    /**
     If `NKError.RequestError` is `clientError`, it attempts to decode the data
     to the given error model, which MUST be `Decodable`.

     If the decoding fails, `nil` is returned.

     - Parameters:
        - errorType: the type of the error model to decode to.
     */
    func decodingError<DecodableError: Decodable>(to errorType: DecodableError.Type) -> DecodableError? {
        guard case .clientError(let data, _) = self else { return nil }
        return try? JSONDecoder().decode(errorType, from: data)
    }

}

extension NKError {

    public var localizedDescription: String {
        let message: String
        switch self {
        case .requestCompletion(let error):
            message = error.localizedDescription
        case .requestCreation(let error):
            message = error.localizedDescription
        }
        return "\(Self.self) - \(message)"
    }

}

extension NKError.RequestCreationError {

    public var localizedDescription: String {
        let message: String
        switch self {
        case .urlEncoding(let url):
            message = "Failed to encode url: \(url)."
        case .pathEncoding(let path):
            message = "Failed to encode path: \(path)."
        case .malformedURL(let url):
            message = "Malformed url: \(url)."
        }
        return "\(Self.self) - \(message)"
    }

}

extension NKError.RequestCompletionError {

    public var localizedDescription: String {
        let message: String
        switch self {
        case .noResponse:
            message = "Got no HTTPURLResponse from the server."
        case .noValue:
            message = "Got no payload from the server."
        case .decoding(let type):
            message = "Failed to decode response of type \(type)."
        }
        return "\(Self.self) - \(message)"
    }

}

extension NKError.RequestError {

    public var localizedDescription: String {
        let message: String
        switch self {
        case .genericError(let error):
            message = "The request failed: \(error.localizedDescription) \(error)"
        case .localError(let error):
            message = "The request failed due to a network error: \(error.localizedDescription)"
        case .clientError(let data, let code):
            message = "The request failed with \(code) error. "
                + "Payload[\(data.count)bytes]: "
                + "\(String(data: data, encoding: .utf8) ?? "cannot show payload")"
        case .serverError(let code):
            message = "The request failed with \(code) error."
        }
        return "\(Self.self) - \(message)"
    }

}

public typealias StatusCode = Int
