//
//  JigsawPieceCollectionViewCell.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class JigsawPieceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func customizeCell(image: UIImage) {
        let newSize = CGSize(width: 200, height: 200)
        let scaledImage = image.scaleToSize(newSize)
        
        imageView.image = scaledImage
    }
}
 