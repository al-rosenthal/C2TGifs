//
//  GiphyAPI.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation

// Search
// https://api.giphy.com/v1/gifs/search?api_key=efATltn9WgdlGJeysUEcTyGTrQBZRfZp&q=&limit=25&offset=0&rating=g&lang=en

// trending
// https://api.giphy.com/v1/gifs/trending?api_key=efATltn9WgdlGJeysUEcTyGTrQBZRfZp&limit=25&rating=g



struct GiphyAPI {
    static let BASE = "https://api.giphy.com/v1/gifs"
    static let API_KEY = "efATltn9WgdlGJeysUEcTyGTrQBZRfZp"
    
    static func favorite() {
        // store this locally, not sure how, DB seems overkill, need
    }
    
    static func search(search: String, offset: Int = 0) {
        let search = "\(BASE)/search?api_key=\(API_KEY)&q=\(search)&limit=50&offset=\(offset)&rating=g&lang=en"
        if let url = URL(string: search) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // check for a successful request
                // map data
                // send it back
            }
            task.resume()
        }
    }
    
    
    static func trending(offset: Int = 0) {
        let trending = "\(BASE)/trending?api_key=\(API_KEY)&limit=25&offset=\(offset)&rating=g"
        print("GET Trending: \(trending)")
        if let url = URL(string: trending) {
            print("MADE URL")
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                    guard let data = data else { return }
//                print(String(data: data!, encoding: .utf8)!)
                // check for a successful request
                // map data
                // send it back
            }
            task.resume()
        }
    }
}

