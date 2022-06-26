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
        if let og = data.images["original"]?["url"] {
            imgGif.sd_setImage(with: URL(string: og))
        }
    }
    
    func loadImage(url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                
            }
        }
    }
    
    @objc func favorite() {
         print("GIF: Favorite Selected")
        
        
        
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        directory
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if paths.count > 0 {
            if let dirPath = paths.first {
                let readPath = URL(fileURLWithPath: dirPath).appendingPathComponent("\(gifData!.id).gif")
                print(readPath.path)
                
                if let myData = imgGif.image?.cgImage?.dataProvider?.data as? Data {
                    print("Managed to get here!!!!")
                    print("Got my data: \(myData.count)")
                    do {
                        try myData.write(to: readPath)
                    } catch {
                        print("NO GOOD: \(error.localizedDescription)")
                    }

                }
                
                
//                let readPath = dirPath.strings(byAppendingPaths: [""])
//                let image = UIImage(named: readPath)
//                let writePath = dirPath.stringByAppendingPathComponent("Image2.png")
//                UIImagePNGRepresentation(image).writeToFile(writePath, atomically: true)
            }
          }
    }
}
