//
//  URLSessionTask+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 8/5/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

extension URLSessionTask {
    
    func addProgressObservation(_ onProgress: ((Double) -> Void)?) -> NSKeyValueObservation? {
        guard let onProgress = onProgress else { return  nil }
        return progress.observe(\.fractionCompleted) { (progress, _) in
            onProgress(progress.fractionCompleted)
        }
    }
    
}
