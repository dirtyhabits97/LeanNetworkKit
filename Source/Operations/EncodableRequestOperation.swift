//
//  EncodableRequestOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/24/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

class EncodableRequestOperation<AnyEncodableRequest: EncodableRequest>: RequestOperation<AnyEncodableRequest> {
    
    override var toUrlRequest: (AnyEncodableRequest) throws -> URLRequest {
        return { request in try URLRequest(encodableRequest: request) }
    }
    
}
