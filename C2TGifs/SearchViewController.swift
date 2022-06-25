//
//  SearchViewController.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation
import UIKit
import SDWebImage

/*
 1. Favorite button
 2. Search function
 3. Download image for offline use
 */

class SearchViewController: UIViewController {
    let REUSE_IDEFNTIFIER = "gif_cell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [GifData] = []
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        GiphyAPI.trending() { items in
            self.updateGifs(items: items)
        }
//        GiphyAPI.search(search: "Skittles")
    }
    
    func updateGifs(items: [GifData]) {
        self.data = items
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    // called when any text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("SEARCH BAR: \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text {
            if (!search.isEmpty) {
                GiphyAPI.search(search: search) { items in
                    self.updateGifs(items: items)
                }
            }
        }
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
            cell.imgGif.sd_setImage(with: URL(string: og))
        }
        
        return cell
    }
}
