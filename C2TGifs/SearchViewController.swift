//
//  SearchViewController.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation
import UIKit
import SDWebImage
import Photos

/*
 1. Favorite button
 3. Download image for offline use
 */

class SearchViewController: UIViewController {
    let REUSE_IDEFNTIFIER = "gif_cell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentData: [GifData] = []
    var apiResults: [GifData] = []
    var favorites: [GifData] = []
    let cache = NSCache<NSString, NSString>()
    override func viewDidLoad() {
        print("View did load")
        collectionView.register(UINib(nibName: "GifViewCell", bundle: nil), forCellWithReuseIdentifier: REUSE_IDEFNTIFIER)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        // request authorization to the photo library
        if (PHPhotoLibrary.authorizationStatus() != .authorized) {
            PHPhotoLibrary.requestAuthorization { status in
//                print("Library Authorization: \(status)")
            }
        }
        
        segmentController.addTarget(self, action: #selector(onSelectorChanged(_:)), for: .valueChanged)
        GiphyAPI.trending() { items in
            self.apiResults = items
            self.updateGifs(items: items)
        }
    }
    
    @objc func onSelectorChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            updateGifs(items: apiResults)
        case 1:
            updateGifs(items: favorites)
        default:
            updateGifs(items: apiResults)
        }
    }
    
    func updateGifs(items: [GifData]) {
//        self.apiResults = items
        currentData = items
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
                    self.apiResults = items
                    self.updateGifs(items: items)
                }
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageData = self.currentData[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDEFNTIFIER, for: indexPath) as! GifViewCell
        
        if let og = imageData.images["original"]?["url"] {
            cell.imgGif.sd_setImage(with: URL(string: og))
        }
        
        return cell
    }
}
