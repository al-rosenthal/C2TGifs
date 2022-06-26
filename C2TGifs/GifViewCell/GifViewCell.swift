//
//  GifViewCell.swift
//  C2TGifs
//
//  Created by Alfred Rosenthal on 2022-06-24.
//

import Foundation
import UIKit
import Photos

class GifViewCell: UICollectionViewCell {
    
    var gifData: GifData? = nil
    
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
        if let og = data.images["original"]?["url"] {
            imgGif.sd_setImage(with: URL(string: og))
        }
    }
    
    @objc func favorite() {
         print("GIF: Favorite Selected")
        // what do I need to do here
        // I need to create an asset
        // I need to save a gif to the animated thing
        // probably also keep a cache or something? or maybe start all the animated from this one with a key
        // so we can tell what is faovrite later?
        PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCreationRequest.forAsset()
            if let og = self.gifData?.images["original"]?["url"] {
            
                DispatchQueue.main.async {
                    if let data = self.imgGif.image?.cgImage?.dataProvider?.data as? Data {
                        request.addResource(with: .photo, data: data, options: nil)
                    }
                }
//                if let url = URL(string: og) {
//                    request.addResource(with: .photo, fileURL: url, options: nil)
//                }
            }
        } completionHandler: { success, error in
            print("GIF: Was this added to the device: \(success)")
            print("GIF: Was there an error: \(String(describing: error?.localizedDescription))")
            
        }

    }
}
