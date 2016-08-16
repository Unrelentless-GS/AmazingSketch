//
//  ViewController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 10/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editButto: UIButton!
    @IBOutlet weak var workingImageView: UIImageView!
    
    var imageView: UIImageView!
    
    var lastPoint: CGPoint?
    var editting: Bool = false
    var initialZoomScale: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "highResImage", inBundle: nil, compatibleWithTraitCollection: nil)
        
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        
        scrollView.contentSize = CGSize(width: (image?.size.width)!, height: (image?.size.height)!)
        
        scrollView.addSubview(imageView)
        
        let scaleFactor = (view.frame.height / scrollView.contentSize.height) < (view.frame.width / scrollView.contentSize.width) ? (view.frame.width / scrollView.contentSize.width) : (view.frame.height / scrollView.contentSize.height)
        
        scrollView.minimumZoomScale = scaleFactor
        scrollView.maximumZoomScale = 10
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        
        scrollView.zoomScale = scaleFactor
        initialZoomScale = scaleFactor
    }
    
    @IBAction func editHandler(sender: UIButton) {
        editing = !editing
        
        let title = !editing ? "Edit" : "Zoom"
        
        scrollView.userInteractionEnabled = !editing
        editButto.setTitle(title, forState: .Normal)
        
        if !editing {
            commitChanges()
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        let workingSize = workingImageView.frame.size
        
        UIGraphicsBeginImageContext(workingSize)
        
        let context = UIGraphicsGetCurrentContext()
        self.workingImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: workingSize.width, height: workingSize.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, 2.0)
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1)
        CGContextSetBlendMode(context, .Normal)
        
        CGContextStrokePath(context)
        
        self.workingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func commitChanges() {
        
        let croppedImage = cropImage()
        let mergedImage = merge(backImage: croppedImage, frontImage: workingImageView.image!)
        let newImage = recreateMainImage(fromImage: mergedImage)
        
        self.imageView.image = newImage
        self.workingImageView.image = nil
    }
    
    func cropImage() -> UIImage {
        
        let cropRect = CGRect(
            x: scrollView.contentOffset.x / scrollView.zoomScale * imageView.image!.scale,
            y: scrollView.contentOffset.y / scrollView.zoomScale * imageView.image!.scale,
            width: workingImageView.image!.size.width / scrollView.zoomScale * imageView.image!.scale,
            height: workingImageView.image!.size.height / scrollView.zoomScale * imageView.image!.scale)
        
        let cgImage = self.imageView.image!.CGImage
        let imageRef = CGImageCreateWithImageInRect(cgImage, cropRect)
        let image: UIImage = UIImage(CGImage: imageRef!, scale: imageView.image!.scale, orientation: imageView.image!.imageOrientation)
        
        return image
    }
    
    func merge(backImage backImage: UIImage, frontImage: UIImage) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(backImage.size, false, 0.0)
        backImage.drawInRect(CGRect(origin: CGPointZero, size: backImage.size))
        frontImage.drawInRect(CGRect(origin: CGPointZero, size: backImage.size))
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return mergedImage
    }
    
    func recreateMainImage(fromImage image: UIImage) -> UIImage {
        
        let size = imageView.image!.size
        let scaledSize = CGSize(width: image.size.width, height: image.size.height)
        
        let contentOffsetX = scrollView.contentOffset.x / scrollView.zoomScale
        let contentOffsetY = scrollView.contentOffset.y / scrollView.zoomScale
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        imageView.image!.drawInRect(CGRect(origin: CGPointZero, size: size))
        image.drawInRect(CGRect(origin: CGPoint(x: contentOffsetX, y: contentOffsetY), size: scaledSize))
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return mergedImage
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
