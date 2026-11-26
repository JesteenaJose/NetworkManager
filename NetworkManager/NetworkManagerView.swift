//
//  ContentView.swift
//  NetworkManager
//
//  Created by macbook on 26/11/26.
//

import SwiftUI

struct NetworkManagerView: View {
    
   @State var postsArray : [Post] = []
    
    var body: some View {
        VStack {
            if !postsArray.isEmpty {
                ForEach(postsArray) { array in
                    /*@START_MENU_TOKEN@*/Text(array.title)/*@END_MENU_TOKEN@*/
                        .lineLimit(2)
                }
            }
        }
        .onAppear {
            getPosts()
        }
        
        .padding()
    }
    
     func getPosts()  {
        let url = "https://dummyjson.com/posts"
        
        guard let urlString = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: URLRequest(url:urlString)) { data, response, error in
            
            guard let data = data ,error == nil else {return}
            
            do {
                let postsResponse = try JSONDecoder().decode(PostsResponse.self, from: data)
                postsArray = postsResponse.posts

            }catch {
                print(error)
            }
            
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkManagerView()
    }
}


struct PostsResponse: Codable, Sendable {
    let posts: [Post]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Post: Codable, Identifiable, Sendable {
    let id: Int
    let title: String
    let body: String
    let tags: [String]
    let reactions: Reactions
    let views: Int
    let userId: Int
}

struct Reactions: Codable, Sendable {
    let likes: Int
    let dislikes: Int
}
