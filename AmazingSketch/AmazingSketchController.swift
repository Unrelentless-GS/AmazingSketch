//
//  AmazingSketchController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 16/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

typealias AmazingSketchSaveCompletionHandler = () -> ()

import UIKit

class AmazingSketchController: NSObject, UIScrollViewDelegate {
    
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
    var saveCompletionHandler: AmazingSketchSaveCompletionHandler?
    
    private var lastPoint: CGPoint?
    private var editing: Bool = false
    
    convenience init(imageSavedCompletionHandler: AmazingSketchSaveCompletionHandler) {
        self.init()
        saveCompletionHandler = imageSavedCompletionHandler
    }
    
    //MARK: PUBLIC
    
    func editHandler(edit: Bool) {
        editing = edit
        
        guard let scrollView = scrollView else { return }
        
        scrollView.userInteractionEnabled = !editing
        
        if !editing { commitChanges() }
    }
    
    func saveHandler() {
        
        let finalImage = imageWithMergedLayers()
        UIImageWriteToSavedPhotosAlbum(finalImage, self, #selector(imageWrittenCompletionHandler(_ :didFinishSavingWithError :contextInfo:)), nil)
    }
    
    //MARK: scroll view delegate
    
    @objc internal func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return backgroundImageView
    }
    
    //MARK: PRIVATE
    
    @objc private func imageWrittenCompletionHandler(image: UIImage, didFinishSavingWithError: NSError, contextInfo: UnsafeMutablePointer<Void>) {
        saveCompletionHandler?()
    }
    
    private func imageWithMergedLayers() -> UIImage {
        guard let background = backgroundImageView else { return UIImage() }
        
        UIGraphicsBeginImageContext(background.image!.size)
        background.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        guard let canvas = canvasImageView else { return }
        
        let workingSize = canvas.frame.size
        
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
        
        createCALayerFromWorkingImage()
        canvas.image = nil
    }
    
    private func createCALayerFromWorkingImage() {
        guard let canvas = canvasImageView else { return }
        guard let background = backgroundImageView else { return }
        guard let scrollView = scrollView else { return }
        
        let scaledRect = CGRect(
            x: scrollView.contentOffset.x / scrollView.zoomScale,
            y: scrollView.contentOffset.y / scrollView.zoomScale,
            width: canvas.frame.size.width / scrollView.zoomScale,
            height: canvas.frame.size.height / scrollView.zoomScale)
        
        let layer = CALayer()
        
        layer.frame = scaledRect
        layer.contents = canvas.image?.CGImage
        
        background.layer.addSublayer(layer)
    }
    
    
    //MARK: UIView touches overrides
    
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
}
