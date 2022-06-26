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
    
    static func favorites(completion: @escaping ([GifData]) -> Void) {
        var liked: [GifData] = []
        do {
            if let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let items = try FileManager.default.contentsOfDirectory(atPath: path.path)
                items.forEach { file in
                    if (file.contains(".gif")) {
                        if let id = file.components(separatedBy: ".").first {
                            liked.append(GifData(id: id, url: "", title: "", images: Images(original: Original(url: path.appendingPathComponent(file).path))))
                        }
                    }
                }
                completion(liked)
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
            completion(liked)
        }
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
    var images: Images
}

struct Images: Decodable {
    var original: Original
}

struct Original: Decodable {
    var height: String?
    var width: String?
    var url: String
}
