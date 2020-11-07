//
//  WSClient.swift
//  LeanNetworkKit
//
//  Created by DIGITAL008 on 11/7/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

@available(iOS 13.0, *)
public class WSClient {
    
    // TODO: document this
    public let queue: OperationQueue
    // TODO: document this
    public let urlSession: URLSession
    
    public init(urlSession: URLSession) {
        self.queue = OperationQueue()
        self.urlSession = urlSession
    }
    
}

// TODO: Handle NKError.WebSocketError

@available(iOS 13.0, *)
extension WSClient {
    
    // TODO: document this
    private func operation<Response>(
        for request: DecodableWebSocket<Response>,
        _ completion: @escaping (Result<Response, Error>) -> Void
    ) -> Operation {
        // TODO: do this
        exit(1)
    }
    
    func connect(
        to ws: WebSocket,
        _ onReceive: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void
    ) {
        // TODO: connect to ws
    }
    
    func connect<Response>(
        to ws: DecodableWebSocket<Response>,
        _ onReceive: @escaping (Result<Response, Error>) -> Void
    ) {
        // TODO: connect to ws
    }
    
}

@available(iOS 13.0, *)
extension WSClient: WebSocketDelegate {
    
    func webSocket(
        _ ws: WebSocketBuilder,
        willSendMessage: URLSessionWebSocketTask.Message
    ) {
        // TODO: send message
    }
    
    func disconnect(ws: WebSocketBuilder) {
        // TODO: disconnect ws
    }
    
}

@available(iOS 13.0, *)
protocol WebSocketDelegate: AnyObject {
    
    func webSocket(
        _ ws: WebSocketBuilder,
        willSendMessage: URLSessionWebSocketTask.Message
    )
    
    func disconnect(ws: WebSocketBuilder)
    
}

@available(iOS 13.0, *)
class WebSocketBuilder {
    
    
    
}

@available(iOS 13.0, *)
class WebSocket: WebSocketBuilder {
    
}

@available(iOS 13.0, *)
class DecodableWebSocket<T>: WebSocketBuilder {
    
}

// FIXME: move to another file
// FIXME: duplicated code from RequestOperation
@available(iOS 13.0, *)
class WSOperation: AsyncOperation {
    
    // MARK: - Properties
    
    private weak var urlSession: URLSession?
    
    // MARK: - Optional properties
    
    // TODO: set the optional properties
    
}
