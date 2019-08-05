//
//  DownloadOperation.swift
//  LeanNetworkKit
//
//  Created by Gonzalo Reyes Huertas on 7/31/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

class DownloadOperation: AsyncOperation, ProgressOperation {
    
    // MARK: - Properties
    
    private weak var urlSession: URLSession?
    
    private let request: DownloadRequest
    private let filename: String?
    private let completion: (Result<URL, Error>) -> Void
    var onProgress: ((Double) -> Void)?
    
    private var task: URLSessionDownloadTask?
    private var token: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    init(
        urlSession: URLSession,
        request: DownloadRequest,
        filename: String?,
        _ completion: @escaping (Result<URL, Error>) -> Void
    ) {
        self.urlSession = urlSession
        self.request = request
        self.filename = filename
        self.completion = completion
    }
    
    override func main() {
        // create url request from download request protocol
        let urlRequest = URLRequest(request)
        // create the download task
        task = urlSession?.downloadTask(for: urlRequest) { [weak self] (result) in
            // avoid retain cycle
            guard let self = self else { return }
            // state should be finished after completing data task
            defer { self.state = .finished }
            // check if it wasn't cancelled
            guard !self.isCancelled else { return }
            // attempt to copy file to cache
            let newResult = result.map(self.copyFileToCache)
            // completion block execution
            self.completion(newResult)
        }
        // add progress observation
        token = task?.addProgressObservation(onProgress)
        // start the download task
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel() // stop task
        token = nil // stop observing
    }
    
    // MARK: - Helper methods
    
    /**
     source:
     https://medium.com/@ji3g4kami/download-store-and-view-pdf-in-swift-af399373b451
     */
    private func copyFileToCache(originalUrl url: URL) throws -> URL {
        // get the cache path
        let cachePath = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0]
        // create the destination path
        let filename = self.filename ?? url.lastPathComponent
        let destinationUrl = cachePath.appendingPathComponent(filename)
        // delete if already exists
        try? FileManager.default.removeItem(at: destinationUrl)
        // copy file to cache
        try FileManager.default.copyItem(at: url, to: destinationUrl)
        return destinationUrl
    }
    
}
