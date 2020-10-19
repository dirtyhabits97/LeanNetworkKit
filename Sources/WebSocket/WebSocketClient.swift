//
//  WebSocketClient.swift
//  LeanNetworkKit
//
//  Created by DIGITAL008 on 10/19/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
public class WSClient {
    
    private let urlSession: URLSession
    
    private var tasks: [UUID: URLSessionWebSocketTask] = [:]
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
}

@available(iOS 13.0, *)
extension WSClient {
    
    func open(
        _ socket: WebSocket,
        _ completion: @escaping (Result<IgnoreResponse, NKError.RequestError>) -> Void
    ) {
        // attempt to create the request
        let urlRequest: URLRequest
        do {
            urlRequest = try socket.build()
        } catch let error {
            // TODO: improve this
            completion(.failure(NKError.RequestError.genericError(error)))
            return
        }
        // create the task
        let task = urlSession.webSocketTask(with: urlRequest)
        task.resume()
        self.receive(task, completion)
        // if ping is specified
        if let pingInterval = socket.components.pingInterval {
            self.ping(task, pingInterval: pingInterval) { (error) in
                // TODO: define error scenario
            }
        }
    }
    
    private func receive(
        _ task: URLSessionWebSocketTask,
        _ completion: @escaping (Result<IgnoreResponse, NKError.RequestError>) -> Void
    ) {
        task.receive { [weak self] result in
            switch result {
            case .success(let message):
                break
            case .failure(let error):
                break
            }
            self?.receive(task, completion)
        }
    }
    
    private func ping(
        _ task: URLSessionWebSocketTask,
        pingInterval: TimeInterval,
        _ failure: @escaping (Error) -> Void
    ) {
        task.sendPing { (error) in
            if let error = error {
                failure(error)
                return
            }
            // send ping
            DispatchQueue
                .global()
                .asyncAfter(deadline: .now() + pingInterval) { [weak self] in
                    self?.ping(task, pingInterval: pingInterval, failure)
                }
        }
    }
    
}

@available(iOS 13.0, *)
extension WSClient: WebSocketDelegate {
    
    func websocket(
        _ socket: WebSocket,
        isSending message: WebSocketComponents.Message
    ) {
        // TODO: do this
    }
    
}
