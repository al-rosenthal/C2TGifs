//
//  GifViewCell.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation
import UIKit
import Photos
import ImageIO

/*
 1. Need to check if gif exists
 2. update favorites accordingly
 3. remove file from directory
 
 nice to have
 1. update for handle proper caching
 2. clean up how data from image is captured, looks gross
 */

class GifViewCell: UICollectionViewCell {
    
    var gifData: GifData? = nil
    var rawData: Data? = nil
    
    @IBOutlet weak var btnFavorite: UIImageView!
    @IBOutlet weak var imgGif: UIImageView!
    @IBOutlet weak var btnUnFavorite: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let favoriteGesture = UITapGestureRecognizer(target: self, action: #selector(favorite))
        btnFavorite.isUserInteractionEnabled = true
        btnFavorite.addGestureRecognizer(favoriteGesture)
        
        
        let unFavoriteGesture = UITapGestureRecognizer(target: self, action: #selector(unFavorite))
        btnFavorite.isHidden = true
        btnUnFavorite.isUserInteractionEnabled = false
        btnUnFavorite.addGestureRecognizer(unFavoriteGesture)
    }
    
    func setupCell(data: GifData) {
        gifData = data
        if let img = getFavorite() {
            toggleFavoriteUI(true)
            imgGif.image = img
        } else {
            toggleFavoriteUI(false)
            imgGif.sd_setImage(with: URL(string: data.images.original.url))
        }
    }
    
    @objc func favorite() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let dirPath = paths.first {
            let readPath = dirPath.appendingPathComponent("\(gifData!.id).gif")
            
            // put this into a cache instead of requesting this again
            DispatchQueue.global().async {
                if let rawData = try? Data(contentsOf: URL(string: self.gifData!.images.original.url)!) {
                    try? rawData.write(to: readPath)
                    self.toggleFavoriteUI(true)
                }
            }
        }
    }
    
    @objc func unFavorite() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let dirPath = paths.first {
            let readPath = dirPath.appendingPathComponent("\(gifData!.id).gif")
            do {
                try? FileManager.default.removeItem(atPath: readPath.path)
                // reload list
            } catch {
                // don't do anything
                // maybe just reload table
            }
        }
    }
    
    func getFavorite() -> UIImage? {
        var image: UIImage? = nil
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let dirPath = paths.first {
            let readPath = dirPath.appendingPathComponent("\(gifData!.id).gif")
            if let raw = try? Data(contentsOf: readPath) {
                image = UIImage.sd_image(with: raw)
            }
        }
        
        return image
    }
    
    func toggleFavoriteUI(_ favorite: Bool) {
        DispatchQueue.main.async {
            if (!favorite) {
                // default behaviour
                self.btnFavorite.isHidden = false
                self.btnFavorite.isUserInteractionEnabled = true
                
                self.btnUnFavorite.isHidden = true
                self.btnUnFavorite.isUserInteractionEnabled = false
            } else {
                // gif is favorited
                self.btnFavorite.isHidden = true
                self.btnFavorite.isUserInteractionEnabled = false
                
                self.btnUnFavorite.isHidden = false
                self.btnUnFavorite.isUserInteractionEnabled = true
            }
        }
    }
}
