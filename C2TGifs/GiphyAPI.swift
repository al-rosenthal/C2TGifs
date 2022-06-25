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
    
    static func search(search: String, offset: Int = 0, completion: @escaping ([GifData]) -> Void) {
        let search = "\(BASE)/search?api_key=\(API_KEY)&q=\(search)&limit=50&offset=\(offset)&rating=g&lang=en"
        if let url = URL(string: search) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    // check if data is available
                    // check if response is in a valid range
                    // check if there are no errors
                    guard let data = data, let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode, error == nil else {
                        throw "Request Failed"
                    }
                    let decodedData = try JSONDecoder().decode(Response.self, from: data)
                    completion(decodedData.data)
                } catch {
                    completion([])
                }
            }.resume()
        }
    }
    
    
    static func trending(offset: Int = 0, completion: @escaping ([GifData]) -> Void) {
        let trending = "\(BASE)/trending?api_key=\(API_KEY)&limit=25&offset=\(offset)&rating=g"
        if let url = URL(string: trending) {
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    // check if data is available
                    // check if response is in a valid range
                    // check if there are no errors
                    guard let data = data, let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode, error == nil else {
                        throw "Request Failed"
                    }
                    let decodedData = try JSONDecoder().decode(Response.self, from: data)
                    completion(decodedData.data)
                } catch {
                    print(error.localizedDescription)
                    completion([])
                }
            }.resume()
        }
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

struct Response: Decodable {
    var data: [GifData]
}

struct GifData: Decodable {
    var id: String
    var url: String
    var title: String
    var images: [String: [String: String]]
}
