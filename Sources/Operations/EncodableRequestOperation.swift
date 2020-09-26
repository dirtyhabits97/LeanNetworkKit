//
//  EncodableRequestOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/24/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

class EncodableRequestOperation<R: EncodableRequest>: RequestOperation<R> {
    
    override func createUrlRequest(from request: R) -> URLRequest {
        return URLRequest(encodableRequest: request)
    }
    
}
