//
//  ContentView.swift
//  Demo
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var store = PostStore()
    
    var body: some View {
        NavigationView {
            List(store.posts) { (post) in
                NavigationLink(destination: PostDetailView(post: post), label: {
                    VStack(alignment: .leading) {
                        Text(post.displayTitle)
                            .font(.title)
                        Text(post.body)
                            .font(.body)
                            .lineLimit(3)
                    }
                })
            }
            .navigationBarTitle("Posts")
        }
        .onAppear(perform: {
            self.store.loadPosts()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
