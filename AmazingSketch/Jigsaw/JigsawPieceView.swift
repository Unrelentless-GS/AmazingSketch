//
//  JigsawPieceView.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

protocol JigsawPieceViewDelegate {
    func jigsawPieceView(jigsawPieceView: JigsawPieceView ,swipedWithDirection: UISwipeGestureRecognizerDirection)
}

class JigsawPieceView: UIView {
    
    lazy var imageView: UIImageView = { [unowned self] in
        guard let imageToRotate = self.roadPiece.roadPieceType.image else { return UIImageView() }
        var image = UIImage()
        
        switch self.roadPiece.orientation {
        case .North:
            image = UIImage(CGImage: imageToRotate.CGImage!,
                            scale: 1.0,
                            orientation: .Down)
        case .South:
            break
        case .East:
            image = UIImage(CGImage: imageToRotate.CGImage!,
                            scale: 1.0,
                            orientation: UIImageOrientation.Left)
        case .West:
            image = UIImage(CGImage: imageToRotate.CGImage!,
                            scale: 1.0,
                            orientation: UIImageOrientation.Right)
        }
        
        return UIImageView(image: image)
        }()
    
    var roadPiece: RoadPiece
    var delegate: JigsawPieceViewDelegate?
    
    private var overlays = [CALayer]()
    
    init(roadPiece: RoadPiece, delegate: JigsawPieceViewDelegate) {
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: (roadPiece.roadPieceType.image?.size)!)
        self.roadPiece = roadPiece
        self.delegate = delegate
        
        super.init(frame: frame)
        
        self.createImageViewConstraints()
        self.createGestureRecogniser()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func removeOverlays() {
        for overlay in overlays {
            overlay.removeFromSuperlayer()
        }
        overlays.removeAll()
    }

    
    //MARK: private
    @objc private func rotate(gesture: UITapGestureRecognizer) {
        let currentOrientation = self.roadPiece.orientation
        self.roadPiece.orientation = JigsawOrientation(rawValue: currentOrientation == .West ? 0 : currentOrientation.rawValue + 1)!
        
        UIView.animateWithDuration(0.5, animations: {
            self.removeOverlays()
            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, CGFloat(M_PI_2))
            
        }) { [unowned self] _ in
            self.createOverlays()
        }
    }
    
    @objc private func swipe(gesture: UISwipeGestureRecognizer) {
        let allowedDirections = self.roadPiece.availableSides
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.Right:
            guard allowedDirections.contains(.East) else { return }
        case UISwipeGestureRecognizerDirection.Left:
            guard allowedDirections.contains(.West) else { return }
        case UISwipeGestureRecognizerDirection.Up:
            guard allowedDirections.contains(.North) else { return }
        case UISwipeGestureRecognizerDirection.Down:
            guard allowedDirections.contains(.South) else { return }
        default:
            break
        }
        delegate?.jigsawPieceView(self, swipedWithDirection: gesture.direction)
    }
    
    private func createGestureRecogniser() {
        let rotateGesture = UITapGestureRecognizer(target: self, action: #selector(rotate))
        rotateGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(rotateGesture)

        let directions: [UISwipeGestureRecognizerDirection] = [.Right, .Left, .Up, .Down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            gesture.direction = direction
            self.addGestureRecognizer(gesture)
        }
    }
    
    private func createImageViewConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.imageView)
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
                x = self.bounds.size.width
                width = lineLength
                height = lineThickness
            case .West:
                y = center.y
                x = self.bounds.origin.x - lineLength
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
            self.overlays.append(layer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.createOverlays()
    }
}
