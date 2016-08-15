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
        
        let scrollViewZoomScale = scrollView.zoomScale - initialZoomScale! == 0 ? 1 : scrollView.zoomScale - initialZoomScale!
        
        let size = scrollView.contentSize
        let workingSize = workingImageView.frame.size
        
        let offsetX = scrollView.contentOffset.x == 0 ? 1 : scrollView.contentOffset.x
        let offsetY = scrollView.contentOffset.y == 0 ? 1 : scrollView.contentOffset.y
        
        let magicMultiplierX: CGFloat = 0.704
        let magicMultiplierY: CGFloat = 0.978
        
        let scaleX = size.width / workingSize.width * magicMultiplierX
        let scaleY = size.height / workingSize.height * magicMultiplierY
        
        let x = offsetX
        let y = offsetY
        let width = workingSize.width
        let height = workingSize.height
        
        UIGraphicsBeginImageContext(size)
        self.imageView.image?.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height), blendMode: .Normal, alpha: 1.0)
        self.workingImageView.image?.drawInRect(CGRect(x: x, y: y, width: width, height: height), blendMode: .Normal, alpha: 1.0)
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.workingImageView.image = nil
        
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
