//
//  AmazingSketchView.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 16/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchView: UIView {
    
    var canvasImageView: UIImageView!
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    weak var controller: AmazingSketchController?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required init(backgroundImage: UIImage, controller: AmazingSketchController) {
        super.init(frame: CGRectZero)
        
        self.controller = controller
        
        createViews(backgroundImage)
        createConstraints(backgroundImage)
        configureScrollView()
        
        controller.amazingSketchView = self
    }
    
    private func createViews(backgroundImage: UIImage) {
        canvasImageView = UIImageView()
        scrollView = UIScrollView()
        imageView = UIImageView(image: backgroundImage)
        
        self.addSubview(canvasImageView)
        self.addSubview(scrollView)
        
        self.scrollView.addSubview(imageView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        canvasImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createConstraints(backgroundImage: UIImage) {
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[scrollView]|",
            options: [],
            metrics: nil,
            views: ["scrollView" : scrollView]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[scrollView]|",
            options: [],
            metrics: nil,
            views: ["scrollView" : scrollView]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[canvasImageView]|",
            options: [],
            metrics: nil,
            views: ["canvasImageView" : canvasImageView]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[canvasImageView]|",
            options: [],
            metrics: nil,
            views: ["canvasImageView" : canvasImageView]))
        
        imageView.frame = CGRect(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height)
        scrollView.contentSize = CGSize(width: backgroundImage.size.width, height: backgroundImage.size.height)
    }
    
    private func configureScrollView() {
        let scaleFactor = (self.frame.height / scrollView.contentSize.height) < (self.frame.width / scrollView.contentSize.width)
            ? (self.frame.width / scrollView.contentSize.width)
            : (self.frame.height / scrollView.contentSize.height)
        
        scrollView.minimumZoomScale = scaleFactor
        scrollView.maximumZoomScale = 10
        scrollView.delegate = controller
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.zoomScale = scaleFactor
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        controller?.touchesMoved(self, touches: touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        controller?.touchesEnded(self, touches: touches, withEvent: event)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureScrollView()
    }
}
