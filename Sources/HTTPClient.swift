//
//  HTTPClient.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/18/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

// TODO: document this
public class HTTPClient {
    
    // TODO: document this
    public let queue: OperationQueue
    // TODO: document this
    public let urlSession: URLSession
    /// The `URL` to use before sending the requests.
    var baseUrl: URL?
    /// Observes the requests.
    var requestObserver: RequestObserver?
    /// Modifies the requests.
    var requestModifier: RequestModifier?
    
    init(urlSession: URLSession) {
        self.queue = OperationQueue()
        self.urlSession = urlSession
    }
    
}
