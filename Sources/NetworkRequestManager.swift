//
//  NetworkRequestManager.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public class HTTPClient {
    
    public let queue: OperationQueue
    public let urlSession: URLSession
    var baseURL: URL?
    
    init(urlSession: URLSession) {
        self.queue = OperationQueue()
        self.urlSession = urlSession
    }
    
}
