//
//  URLSession+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension URLSession {
    
    // MARK: - Data task
    
    func dataTask(
        for urlRequest: URLRequest,
        _ completion: @escaping (URLSessionTaskResult) -> Void
    ) -> URLSessionDataTask {
        let task = dataTask(with: urlRequest) { (data, response, error) in
            // check if URLError
            if let error = error as? URLError {
                return completion(.localFailure(error))
            // check if generic error
            } else if let error = error {
                return completion(.genericFailure(error))
            }
            // validate there is an HTTPURLResponse
            guard let response = response as? HTTPURLResponse else {
                return completion(.genericFailure(NKError.requestCompletion(.noResponse)))
            }
            // validate status code
            if response.statusCode >= 400 && response.statusCode <= 499 {
                return completion(.clientFailure(data ?? Data(), response))
            }
            if response.statusCode >= 500 && response.statusCode <= 599 {
                return completion(.serverFailure(response))
            }
            // validate value
            guard let data = data else {
                return completion(.genericFailure(NKError.requestCompletion(.noValue)))
            }
            // success scenario
            return completion(.success(data, response))
        }
        return task
    }
    
    /**
     A strongly typed Result for `URLSessionTask` completions.
     */
    enum URLSessionTaskResult {

        // MARK: - Cases

        /**
         A non-network related error happened.
         */
        case genericFailure(Error)
        /**
         The request didn't get to the server.
         */
        case localFailure(URLError)
        /**
         The request failed because of the client (status code 4XX).
         */
        case clientFailure(Data, HTTPURLResponse)
        /**
         The request failed because of the server (status code 5XX).
         */
        case serverFailure(HTTPURLResponse)
        /**
         The request succeeded.
         */
        case success(Data, HTTPURLResponse)

        // MARK: - Properties

        var value: Data? {
            switch self {
            case .genericFailure, .localFailure, .serverFailure: return nil
            case .clientFailure(let d, _): return d
            case .success(let d, _): return d
            }
        }

        var response: HTTPURLResponse? {
            switch self {
            case .genericFailure, .localFailure: return nil
            case .serverFailure(let r): return r
            case .clientFailure(_, let r): return r
            case .success(_, let r): return r
            }
        }

    }
    
}
