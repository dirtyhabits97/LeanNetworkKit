//
//  PostDetailView.swift
//  Demo
//
//  Created by Gonzalo Reyes Huertas on 9/26/20.
//  Copyright © 2020 Gonzalo Reyes Huertas. All rights reserved.
//

import SwiftUI

struct PostDetailView: View {
    
    let post: Post
    
    @ObservedObject var store = CommentStore()
    
    var body: some View {
        VStack {
            Text(post.body)
                .italic()
                .padding(.leading, 12)
            List(store.comments) { (comment) in
                VStack(alignment: .leading) {
                    Text(comment.name)
                        .font(.subheadline)
                        .bold()
                    Text(comment.body)
                        .font(.footnote)
                    Text(comment.email)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
            }
        }
        .navigationBarTitle(post.displayTitle)
        .onAppear(perform: {
            self.store.loadComments(forPostWithId: self.post.id)
        })
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: Post(userId: 1, id: 1, title: "My post's title", body: "soem body goes here"))
    }
}
