//
//  PostStore.swift
//  Demo
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation
import LeanNetworkKit
import Combine

let client = HTTPClient(urlSession: URLSession(configuration: .ephemeral))
    .observeRequests(requestWillLoad: { (request) in
        var str = request.httpMethod?.uppercased() ?? "-"
        str += "\t"
        str += request.url?.absoluteString ?? "-"
        print(str)
    }, requestDidLoad: { (req, res, data) in
        var str = "Headers: [\n"
        for (key, val) in res.allHeaderFields {
            str += "\t\(key):\t\(val)\n"
        }
        str += "]\n"
        str += "Bytes: \(data?.count ?? 0)"
        print(str)
    }, requestDidSucceed: { (req, _) in
        print("Request did succeed")
    }, requestDidFail: { (req, error) in
        print("Request did fail", error.localizedDescription)
    }, didCancelRequest: { _ in
        print("Request was canceled.")
    })
    .modifyRequests({ (request) in
        request.addValue("Accept", forHTTPHeaderField: "application/json")
    })

class PostStore: ObservableObject {
    
    @Published var posts: [Post] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadPosts() {
        let request = Request(url: .baseURL, path: "/posts", method: .get)
            .decode(to: [Post].self)
        client
            .publisher(for: request)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.posts, on: self)
            .store(in: &cancellables)
    }
    
}

extension URL {
    
    static let baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    
}
