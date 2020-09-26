//
//  CommentStore.swift
//  Demo
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation
import LeanNetworkKit
import Combine

class CommentStore: ObservableObject {
    
    @Published var comments: [Comment] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadComments(forPostWithId id: Int) {
        let request = Request(url: .baseURL, path: "/comments", method: .get)
            .addQueryItem(key: "postId", val: String(id))
            .decode(to: [Comment].self)
        client
            .publisher(for: request)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.comments, on: self)
            .store(in: &cancellables)
    }
    
}
