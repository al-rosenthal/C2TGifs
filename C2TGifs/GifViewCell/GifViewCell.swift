//
//  GifViewCell.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation
import UIKit
import Photos

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

    override func awakeFromNib() {
        super.awakeFromNib()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(favorite))
        btnFavorite.isUserInteractionEnabled = true
        btnFavorite.addGestureRecognizer(singleTap)
    }
    
    func setupCell(data: GifData) {
        gifData = data
        
        print("GIF: \(data.images.original.url)")
        
        if let img = getFavorite() {
            imgGif.image = img
        } else {
            imgGif.sd_setImage(with: URL(string: data.images.original.url))
        }
    }
    
    @objc func favorite() {
         print("GIF: Favorite Selected")

        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let dirPath = paths.first {
            let readPath = dirPath.appendingPathComponent("\(gifData!.id).gif")
            print(readPath.path)
            
            // would like to get a cleaner implementation of this
            if let myData = imgGif.image?.cgImage?.dataProvider?.data as? Data {
                do {
                    try myData.write(to: readPath)
                } catch {
                    print("NO GOOD: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func getFavorite() -> UIImage? {
        print("GIF: GET FAVORITE")
        var image: UIImage? = nil
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let dirPath = paths.first {
            let readPath = dirPath.appendingPathComponent("\(gifData!.id).gif")
            print("GIF: \(readPath.path)")
            image = UIImage(contentsOfFile: readPath.path)
            print("GIF: Image: \(image)")
        }
        return image
    }
}
