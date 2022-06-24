//
//  SearchViewController.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        print("VIEW DID LOAD")
//        GiphyAPI.trending()
        GiphyAPI.search(search: "Skittles")
    }
}
