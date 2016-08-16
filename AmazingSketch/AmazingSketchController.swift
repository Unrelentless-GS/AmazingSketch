//
//  AmazingSketchController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 16/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

protocol AmazingSketchTouchable {
    func touchesMoved(view: UIView, touches: Set<UITouch>, withEvent event: UIEvent?)
    func touchesEnded(view: UIView, touches: Set<UITouch>, withEvent event: UIEvent?)
    func editHandler(edit: Bool)
}

class AmazingSketchController: NSObject, UIScrollViewDelegate, AmazingSketchTouchable {
    
    private weak var backgroundImageView: UIImageView? {
        guard let amazingSketchView = self.amazingSketchView else { return nil }
        return amazingSketchView.imageView
    }
    
    private weak var canvasImageView: UIImageView? {
        guard let amazingSketchView = self.amazingSketchView else { return nil }
        return amazingSketchView.canvasImageView
    }
    
    private weak var scrollView: UIScrollView? {
        guard let amazingSketchView = self.amazingSketchView else { return nil }
        return amazingSketchView.scrollView
    }
    
    weak var amazingSketchView: AmazingSketchView?
    
    private var lastPoint: CGPoint?
    private var editing: Bool = false
    
    @objc internal func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.backgroundImageView
    }
    
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        guard let canvas = canvasImageView else { return }
        
        let workingSize = canvas.image!.size
        
        UIGraphicsBeginImageContext(workingSize)
        
        let context = UIGraphicsGetCurrentContext()
        canvas.image?.drawInRect(CGRect(x: 0, y: 0, width: workingSize.width, height: workingSize.height))
        
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        CGContextSetLineCap(context, .Round)
        CGContextSetLineWidth(context, 2.0)
        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1)
        CGContextSetBlendMode(context, .Normal)
        
        CGContextStrokePath(context)
        
        canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func commitChanges() {
        guard let canvas = canvasImageView else { return }
        guard let background = backgroundImageView else { return }
        
        scaleWorkingImage()
        
        let newImage = recreateMainImage(fromImage: canvas.image!)
        
        background.image = newImage
        canvas.image = nil
    }
    
    private func scaleWorkingImage() {
        guard let canvas = canvasImageView else { return }
        guard let scrollView = scrollView else { return }
        
        let scaledRect = CGRect(
            x: 0,
            y: 0,
            width: canvas.image!.size.width / scrollView.zoomScale,
            height: canvas.image!.size.height / scrollView.zoomScale)
        
        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0)
        canvas.image!.drawInRect(scaledRect)
        canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func recreateMainImage(fromImage image: UIImage) -> UIImage {
        guard let background = backgroundImageView else { return UIImage() }
        guard let scrollView = scrollView else { return UIImage() }
        
        let size = background.image!.size
        let scaledSize = CGSize(width: image.size.width, height: image.size.height)
        
        let contentOffsetX = scrollView.contentOffset.x / scrollView.zoomScale
        let contentOffsetY = scrollView.contentOffset.y / scrollView.zoomScale
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        background.image!.drawInRect(CGRect(origin: CGPointZero, size: size))
        image.drawInRect(CGRect(origin: CGPoint(x: contentOffsetX, y: contentOffsetY), size: scaledSize))
        
        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return mergedImage
    }
    
    internal func touchesMoved(view: UIView, touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            
            if lastPoint == nil { lastPoint = currentPoint }
            
            drawLineFrom(lastPoint!, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    internal func touchesEnded(view: UIView, touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastPoint = nil
    }
    
    func editHandler(edit: Bool) {
        editing = edit
        
        guard let scrollView = scrollView else { return }
        
        scrollView.userInteractionEnabled = !editing
        
        if !editing {
            commitChanges()
        }
    }
}
