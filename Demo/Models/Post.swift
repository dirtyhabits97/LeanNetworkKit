//
//  Post.swift
//  Demo
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

struct Post: Codable, Identifiable {
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
    
    var displayTitle: String {
        title.split(separator: " ")[0...2].joined(separator: " ")
    }
    
}
