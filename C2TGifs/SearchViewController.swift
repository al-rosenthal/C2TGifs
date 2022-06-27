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
    @IBOutlet weak var lblNoFavorites: UILabel!
    @IBOutlet weak var lblNoGifsFound: UILabel!
    
    var currentData: [GifData] = []
    var apiResults: [GifData] = []
    var favorites: [GifData] = []
    let cache = NSCache<NSString, NSString>()
    override func viewDidLoad() {
        // use custom nib for collection view
        collectionView.register(UINib(nibName: "GifViewCell", bundle: nil), forCellWithReuseIdentifier: REUSE_IDEFNTIFIER)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.delegate = self
        
        segmentController.addTarget(self, action: #selector(onSelectorChanged(_:)), for: .valueChanged)
        
        // grab trending gifs when app loads
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
            GiphyAPI.favorites() { favorites in
                self.favorites = favorites
                self.updateGifs(items: favorites)
            }
        default:
            updateGifs(items: apiResults)
        }
    }
    
    func updateGifs(items: [GifData]) {
        currentData = items
        DispatchQueue.main.async {
            self.lblNoGifsFound.isHidden = true
            self.lblNoFavorites.isHidden = true
            
            // check if error labels need to be displayed
            if (self.currentData.count <= 0) {
                switch self.segmentController.selectedSegmentIndex{
                case 0:
                    self.lblNoGifsFound.isHidden = false
                case 1:
                    self.lblNoFavorites.isHidden = false
                default:
                    self.lblNoGifsFound.isHidden = true
                    self.lblNoFavorites.isHidden = true
                }
            }
            self.collectionView.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    // called when any text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("SEARCH BAR: \(searchText)")
    }
    
    // runs when the Search or Enter button is hit
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
        
        cell.setupCell(data: imageData) { id in
            self.currentData.removeAll { data in
                data.id == id
            }
            self.updateGifs(items: self.currentData)
        }
        
        return cell
    }
}
