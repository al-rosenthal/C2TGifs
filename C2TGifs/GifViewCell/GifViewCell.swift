//
//  GifViewCell.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation
import UIKit

class GifViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnFavorite: UIImageView!
    @IBOutlet weak var imgGif: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(favorite))
        btnFavorite.isUserInteractionEnabled = true
        btnFavorite.addGestureRecognizer(singleTap)
    }
    
    @objc func favorite() {
         print("Favorite Selected")
        
    }
}
