//
//  ViewController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 10/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButto: UIButton!
    
    var imageView: UIImageView!
    
    var lastPoint: CGPoint?
    var editting: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let image = UIImage(named: "highResImage", inBundle: nil, compatibleWithTraitCollection: nil)
        
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        
        scrollView.contentSize = CGSize(width: (image?.size.width)!, height: (image?.size.height)!)
        
        scrollView.addSubview(imageView)
    
        let scaleFactor = view.frame.width / scrollView.contentSize.width
        
        scrollView.minimumZoomScale = scaleFactor
        scrollView.maximumZoomScale = 10
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        
        scrollView.zoomScale = scaleFactor
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func editHandler(sender: UIButton) {
        editing = !editing
        
        let title = !editing ? "Edit" : "Zoom"
        
        scrollView.userInteractionEnabled = !editing
        editButto.setTitle(title, forState: .Normal)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        print("from: \(fromPoint) \n to: \(toPoint)\n")
        
        UIGraphicsBeginImageContext(view.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        self.imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        let from = imageView.pointInAspectScaleFitImageCoordinates(fromPoint)
        let to = imageView.pointInAspectScaleFitImageCoordinates(toPoint)
        
        CGContextMoveToPoint(context, from.x, from.y)
        CGContextAddLineToPoint(context, to.x, to.y)
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, 2.0)
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1.0)
        CGContextSetBlendMode(context, .Normal)
        
        CGContextStrokePath(context)
        
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            
            if lastPoint == nil { lastPoint = currentPoint }
            
            drawLineFrom(lastPoint!, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastPoint = nil
    }
}

extension UIImageView {
    
    func pointInAspectScaleFitImageCoordinates(point:CGPoint) -> CGPoint {
        
        if let img = image {
            
            let imageSize = img.size
            let imageViewSize = frame.size
            
            let imgRatio = imageSize.width/imageSize.height // The ratio of the image before scaling.
            let imgViewRatio = imageViewSize.width/imageViewSize.height // The ratio of the image view
            
            let ratio = (imgRatio > imgViewRatio) ? imageSize.width/imageViewSize.width:imageSize.height/imageViewSize.height // The ratio of the image before scaling to after scaling.
            
            let xOffset = (imageSize.width-(imageViewSize.width*ratio))*0.5 // The x-offset of the image on-screen (as it gets centered)
            let yOffset = (imageSize.height-(imageViewSize.height*ratio))*0.5 // The y-offset of the image on-screen (as it gets centered)
            
            let subImgOrigin = CGPoint(x: point.x*ratio, y: point.y*ratio); // The origin of the image (relative to the origin of the view)
            
            return CGPoint(x: subImgOrigin.x+xOffset, y: subImgOrigin.y+yOffset);
        }
        return CGPointZero
    }
}
