//
//  Bundle+Extensions.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 5/3/19.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

public extension Bundle {
    
    func data(from filename: String) throws -> Data {
        guard let url = url(forResource: filename, withExtension: nil) else {
            throw BundleError.fileNotInBundle(self, filename)
        }
        return try Data(contentsOf: url)
    }
    
}

enum BundleError: Error {
    
    case fileNotInBundle(Bundle, String)
    
    var localizedDescription: String {
        switch self {
        case let .fileNotInBundle(bundle, filename):
            return "File \(filename) not found in bundle \(bundle.bundleIdentifier ?? bundle.bundlePath)"
        }
    }
    
}
