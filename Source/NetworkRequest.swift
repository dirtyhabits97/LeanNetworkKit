//
//  NetworkRequest.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

// MARK: - Error

enum NetworkRequestError: LocalizedError {
    
    case client(code: Int)
    case server(code: Int)
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .client(let code): return "Client side error: \(code)"
        case .server(let code): return "Server side error: \(code)"
        case .emptyData: return "Received empty data"
        }
    }
    
}

// MARK: - NetworkRequest

protocol NetworkRequest {
    
    associatedtype Model
    
    var urlSession: URLSession? { get }
    
    func load(_ completion: @escaping (Result<Model>) -> Void)
    func decode(_ data: Data) -> Result<Model>
    
}

extension NetworkRequest {
    
    func loadModel(urlRequest: URLRequest, then completion: @escaping (Result<Model>) -> Void) {
        let session = (urlSession ?? URLSession(configuration: .ephemeral))
        session.load(urlRequest: urlRequest) { (result) in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(let data): completion(self.decode(data))
            }
        }
    }
    
}

// MARK: - Helper method

private extension URLSession {
    
    func load(urlRequest: URLRequest, _ completion: @escaping (Result<Data>) -> Void) {
        dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let e = error {
                print("Network Request Error. \(e)")
                completion(.failure(e))
                return
            }
            
            if let code = (response as? HTTPURLResponse)?.statusCode {
                if (code/100) == 4 {
                    print("Network Request Error. Client side error: \(code)")
                    completion(.failure(NetworkRequestError.client(code: code)))
                    return
                } else if (code/100) == 5 {
                    print("Network Request Error. Server side error: \(code)")
                    completion(.failure(NetworkRequestError.server(code: code)))
                    return
                }
            }
            
            guard let data = data else {
                print("Network Request Error. Didn't receive data")
                completion(.failure(NetworkRequestError.emptyData))
                return
            }
            
            print("Network Request Success")
            completion(.success(data))
        }).resume()
    }
    
}
