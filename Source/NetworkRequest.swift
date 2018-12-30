//
//  NetworkRequest.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 10/27/18.
//  Copyright © 2018 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

enum NetworkRequestError: LocalizedError {
    
    case client
    case server
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .client: return "Client side error"
        case .server: return "Server side error"
        case .emptyData: return "Received empty data"
        }
    }
    
}

protocol NetworkRequest {
    
    associatedtype Model
    
    func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (Result<Model>) -> Void)
    func decode(_ data: Data) -> Result<Model>
    
}

extension NetworkRequest {
    
    func load(_ urlRequest: URLRequest, withCompletion completion: @escaping (Result<Model>) -> Void) {
        let configuration = URLSessionConfiguration.ephemeral
        let urlSession = URLSession(configuration: configuration)
        urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let e = error {
                print("Network Request Error. \(e)")
                DispatchQueue.main.async { completion(.failure(e)) }
                return
            }
            
            if let status = (response as? HTTPURLResponse)?.statusCode {
                if (status/100) == 4 {
                    print("Client side error ", status)
                    DispatchQueue.main.async { completion(.failure(NetworkRequestError.client)) }
                    return
                } else if (status/100) == 5 {
                    print("Server side error ", status)
                    DispatchQueue.main.async { completion(.failure(NetworkRequestError.server)) }
                    return
                }
            }
            
            guard let d = data else {
                print("Network Request Error. Didn't receive data")
                DispatchQueue.main.async { completion(.failure(NetworkRequestError.emptyData)) }
                return
            }
            
            print("Network Request Success")
            DispatchQueue.main.async { completion(self.decode(d)) }
        }).resume()
    }
    
}
