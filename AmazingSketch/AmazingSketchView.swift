//
//  AmazingSketchView.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 16/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchView: UIView {
    
    var canvasImageView: AmazingSketchDrawingView!
    var scrollView: AmazingSketchScrollView!
    var imageView: UIImageView!
    
    weak var drawingController: AmazingSketchDrawingController?
    weak var stickerController: AmazingSketchStickerController?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    required init(backgroundImage: UIImage, drawingController: AmazingSketchDrawingController? = nil, stickerController: AmazingSketchStickerController? = nil) {
        super.init(frame: CGRectZero)
        
        self.drawingController = drawingController
        self.stickerController = stickerController
        
        createViews(backgroundImage)
        createConstraints(backgroundImage)
        
        guard let drawingController = drawingController else { return }
        
        drawingController.amazingSketchView = self
        
        guard let stickerController = stickerController else { return }
        
        stickerController.amazingSketchView = self
        stickerController.createGestures()        
    }
    
    private func createViews(backgroundImage: UIImage) {
        canvasImageView = AmazingSketchDrawingView(controller: drawingController)
        scrollView = AmazingSketchScrollView()
        imageView = UIImageView(image: backgroundImage)
        
        addSubview(canvasImageView)
        addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        
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
        
        imageView.frame = CGRect(x: 0, y: 0, width: imageView.image!.size.width, height: imageView.image!.size.height)
        scrollView.contentSize = CGSize(width: imageView.image!.size.width, height: imageView.image!.size.height)
//        
//        print("\n***********BEFORE*********")
//        print("\ncurrent frame \(frame)")
//        print("\nscrollView content size: \(scrollView.contentSize)")
//        print("\nscrollView zoom scale: \(scrollView.zoomScale)")
//        print("\nimageView image \(imageView.image!)")
        
        let scaleFactor = (frame.height / scrollView.contentSize.height) < (frame.width / scrollView.contentSize.width)
            ? (frame.width / scrollView.contentSize.width)
            : (frame.height / scrollView.contentSize.height)
        
        scrollView.minimumZoomScale = scaleFactor
        scrollView.maximumZoomScale = 10
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.zoomScale = scaleFactor
        sendSubviewToBack(scrollView)
        
//        print("\n***********AFTER*************")
//        print("\ncurrent frame \(frame)")
//        print("\nscrollView content size: \(scrollView.contentSize)")
//        print("\nscrollView zoom scale: \(scrollView.zoomScale)")
//        print("\nimageView image \(imageView.image!)")
        
        guard let drawingController = drawingController else { return }
        
        scrollView.delegate = drawingController
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureScrollView()
    }
}
