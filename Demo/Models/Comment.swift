//
//  Comment.swift
//  Demo
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import Foundation

struct Comment: Codable, Identifiable {
    
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
    
}
