//
//  SearchViewController.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation
import UIKit
import SDWebImage

class SearchViewController: UIViewController {
    let REUSE_IDEFNTIFIER = "gif_cell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [GifData] = []
    
    override func viewDidLoad() {
        print("VIEW DID LOAD")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        GiphyAPI.trending() { items in
            print("TRENDING RESPONDED")
            self.data = items
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
//        GiphyAPI.search(search: "Skittles")
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageData = self.data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDEFNTIFIER, for: indexPath) as! GifViewCell
        
        if let og = imageData.images["original"]?["url"] {
            print("DEQUE CELL: \(og)")
            cell.imgGif.sd_setImage(with: URL(string: og))
        }
//        if let d = self.data[indexPath.row] {
//            if let img = d.images["original"]?["url"] {
//
//            }
//        }
        
        return cell
    }
}
