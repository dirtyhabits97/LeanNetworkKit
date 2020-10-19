//
//  WebSocket.swift
//  LeanNetworkKit
//
//  Created by DIGITAL008 on 10/19/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

protocol WebSocketDelegate: AnyObject {
    
    func websocket(
        _ socket: WebSocket,
        isSending message: WebSocketComponents.Message
    )
    
}

// Builder
public class WebSocket {
    
    private weak var delegate: WebSocketDelegate?
    
    private(set) var components: WebSocketComponents
    
    var id: UUID?
    
    init(components: WebSocketComponents) {
        self.components = components
    }
    
    func setPingInterval(_ interval: TimeInterval) -> Self {
        // TODO: set this
        return self
    }
    
    func send(_ string: String) -> Self {
        delegate?.websocket(self, isSending: .string(string))
        return self
    }
    
    func build() throws -> URLRequest {
        try components.toURLRequest()
    }
    
}

struct WebSocketComponents {
    
    var url: URL
    var path: String
    var message: Message?
    var pingInterval: TimeInterval?
    
    func toURLRequest() throws -> URLRequest {
        URLRequest(url: url)
    }
}

extension WebSocketComponents {
    
    enum Message {
        
        case string(String)
        case data(Data)
        case dataFromFile(String, Bundle)
        case dataFromFileURL(URL)
        case dataFromClosure(@autoclosure () throws -> Data)
        
    }
    
}
