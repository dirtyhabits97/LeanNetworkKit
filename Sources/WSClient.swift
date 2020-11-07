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
    
    public let queue: DispatchQueue
    // TODO: document this
    public let urlSession: URLSession
    // TODO: document this
    private var connections: [UUID: WSConnection] = [:]
    
    public init(urlSession: URLSession) {
        self.queue = DispatchQueue(
            label: "com.gerh.LeanNetworkKit.WSClient",
            qos: .utility,
            attributes: .concurrent
        )
        self.urlSession = urlSession
    }
    
}

@available(iOS 13.0, *)
protocol WSConnection {
    
    func send(message: URLSessionWebSocketTask.Message)
    
    func disconnect()
    
}

@available(iOS 13.0, *)
private class _WSConnection<Output>: WSConnection {
    
    private let builder: DecodableWebSocket<Output>
    private let pingTimeInterval: TimeInterval
    private var task: URLSessionWebSocketTask?
    private let onReceive: (Result<Output, Error>) -> Void
    
    init(
        urlSession: URLSession,
        ws: DecodableWebSocket<Output>,
        queue: DispatchQueue,
        _ completion: @escaping (Result<Output, Error>) -> Void
    ) throws {
        builder = ws
        pingTimeInterval = ws.components.pingTimeInterval
        task = urlSession.webSocketTask(with: try ws.build())
        onReceive = completion
        
        receive(on: queue)
        ping(on: queue)
    }
    
    func receive(on queue: DispatchQueue) {
        task?.receive { (result) in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    if let output = try? self.builder.internalDecode(data) {
                        self.onReceive(.success(output))
                        self.receive(on: queue)
                    } else {
                        // TODO: notify error
                    }
                default:
                    break
                    // TODO: notify error
                }
            case .failure(let error):
                self.onReceive(.failure(error))
                self.fail(error: error, code: .invalid)
            }
        }
    }
    
    func ping(on queue: DispatchQueue) {
        task?.sendPing { [weak self] (error) in
            guard let self = self else { return }
            if let error = error {
                self.fail(error: error, code: .noStatusReceived)
                return
            }
            queue.asyncAfter(deadline: .now() + self.pingTimeInterval) { [weak self] in
                self?.ping(on: queue)
            }
        }
    }
    
    func send(message: URLSessionWebSocketTask.Message) {
        task?.send(message) { [weak self] (error) in
            if let error = error {
                self?.fail(error: error, code: .invalid)
            }
        }
    }
    
    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
    }
    
    private func fail(error: Error, code: URLSessionWebSocketTask.CloseCode) {
        task?.cancel(with: code, reason: nil)
        onReceive(.failure(error))
        task = nil
    }
    
}

// TODO: Handle NKError.WebSocketError

@available(iOS 13.0, *)
extension WSClient {
    
    func connect<Response>(
        to ws: DecodableWebSocket<Response>,
        _ onReceive: @escaping (Result<Response, Error>) -> Void
    ) {
        guard ws.id == nil else {
            fatalError("TODO: set this message")
        }
        guard let connection = try? _WSConnection(
            urlSession: urlSession,
            ws: ws,
            queue: queue,
            onReceive
        ) else {
            return
        }
        let id = UUID()
        ws.id = id
        connections[id] = connection
    }
    
}

@available(iOS 13.0, *)
extension WSClient: WebSocketDelegate {
    
    func webSocket(
        _ ws: WebSocketBuilder,
        willSend message: URLSessionWebSocketTask.Message
    ) {
        guard
            let id = ws.id,
            let connection = connections[id]
        else {
            return
        }
        connection.send(message: message)
    }
    
    func disconnect(ws: WebSocketBuilder) {
        guard
            let id = ws.id,
            let connection = connections[id]
        else {
            return
        }
        connection.disconnect()
        connections.removeValue(forKey: id)
    }
    
}

@available(iOS 13.0, *)
protocol WebSocketDelegate: AnyObject {
    
    func webSocket(
        _ ws: WebSocketBuilder,
        willSend message: URLSessionWebSocketTask.Message
    )
    
    func disconnect(ws: WebSocketBuilder)
    
}

// MARK: - Pretty API

@available(iOS 13.0, *)
struct WebSocketComponents {
    
    var url: URL
    var path: String
    var pingTimeInterval: TimeInterval = 30
    
    func toURLRequest() throws -> URLRequest {
        try URLRequestBuilder.urlRequest(from: self)
    }
    
}

@available(iOS 13.0, *)
class WebSocketBuilder {
    
    weak var delegate: WebSocketDelegate?
    
    var id: UUID?
    
    var components: WebSocketComponents
    
    init(components: WebSocketComponents) {
        self.components = components
    }
    
    init(url: URL, path: String) {
        components = WebSocketComponents(url: url, path: path)
    }
    
    func build() throws -> URLRequest {
        try components.toURLRequest()
    }
    
}

@available(iOS 13.0, *)
class DecodableWebSocket<T>: WebSocketBuilder {
    
    let internalDecode: (Data) throws -> T
    
    init(
        components: WebSocketComponents,
        decode: @escaping (Data) throws -> T
    ) {
        internalDecode = decode
        super.init(components: components)
    }
    
}
