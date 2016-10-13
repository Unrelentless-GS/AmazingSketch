//
//  JigsawPieceView.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class JigsawPieceView: UIView {
    
    var imageView: UIImageView
    var roadPiece: RoadPiece
    
    init(roadPiece: RoadPiece) {
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: (roadPiece.roadPieceType.image?.size)!)
        self.roadPiece = roadPiece
        self.imageView = UIImageView(image: roadPiece.roadPieceType.image)
        
        super.init(frame: frame)
        
        self.createImageViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func createImageViewConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
        let horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[image]|",
                                                                                  options: [],
                                                                                  metrics: nil,
                                                                                  views: ["image": self.imageView])
        let verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[image]|",
                                                                                options: [],
                                                                                metrics: nil,
                                                                                views: ["image": self.imageView])
        
        NSLayoutConstraint.activateConstraints(horizontalConstraint)
        NSLayoutConstraint.activateConstraints(verticalConstraint)
    }
    
    private func createOverlays() {
        var layers = [CALayer]()
        
        print(self.frame, self.bounds, self.center)
        
        roadPiece.availableSides.forEach { [unowned self] side in
            let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
            let lineThickness: CGFloat = 2.0
            let lineLength: CGFloat = 15.0
            
            var x: CGFloat
            var y: CGFloat
            var width: CGFloat
            var height: CGFloat
            
            switch side {
            case .North:
                x = center.x
                y = self.bounds.origin.y - lineLength
                width = lineThickness
                height = lineLength
            case .South:
                x = center.x
                y = self.bounds.size.height
                width = lineThickness
                height = lineLength
            case .East:
                y = center.y
                x = self.bounds.origin.x - lineLength
                width = lineLength
                height = lineThickness
            case .West:
                y = center.y
                x = self.bounds.size.width
                width = lineLength
                height = lineThickness
            }
            
            let layer = CALayer()
            layer.backgroundColor = UIColor.magentaColor().CGColor
            layer.shadowRadius = 2.0
            layer.frame = CGRect(x: x, y: y, width: width, height: height)
            layer.masksToBounds = false
            
            layers.append(layer)
            self.layer.addSublayer(layer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.createOverlays()
    }
}
