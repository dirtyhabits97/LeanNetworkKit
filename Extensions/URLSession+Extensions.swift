//
//  URLSession+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension URLSession {
    
    @discardableResult
    func dataTask(
        for urlRequest: URLRequest,
        _ completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        let dataTask = self.dataTask(with: urlRequest) { (data, response, error) in
            // generic error
            if let error = error {
                completion(.failure(error))
                return
            }
            // check response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion(.failure(RequestError.notAnHTTPRequest))
                return
            }
            // check status code
            guard (200...299).contains(statusCode) else {
                completion(.failure(RequestError.statusCodeError(statusCode)))
                return
            }
            // success
            completion(.success(data ?? Data()))
        }
        return dataTask
    }
    
}
