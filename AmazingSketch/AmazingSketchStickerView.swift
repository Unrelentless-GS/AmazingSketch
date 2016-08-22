//
//  AmazingViewStickerView.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 19/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchStickerView: UIImageView {
    
    var focusGesture: UITapGestureRecognizer?
    var panGesture: UIPanGestureRecognizer?
    var pinchGesture: UIPinchGestureRecognizer?
    var rotateGesture: UIRotationGestureRecognizer?
    
    private var lastLocation: CGPoint = CGPointZero
    private weak var gestureDelegate: UIGestureRecognizerDelegate?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    convenience init(image: UIImage, gestureRecogniserDelegate: UIGestureRecognizerDelegate?) {
        self.init(image: image)
        self.gestureDelegate = gestureRecogniserDelegate
        
        focusGesture!.delegate = gestureDelegate
        panGesture!.delegate = gestureDelegate
        pinchGesture!.delegate = gestureDelegate
        rotateGesture!.delegate = gestureDelegate
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        setupGesture()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }
    
    private func setupGesture() {
        self.userInteractionEnabled = true
        
        focusGesture = UITapGestureRecognizer(target: self, action: #selector(handleFocus(_:)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(_:)))
        
        self.focusGesture?.numberOfTapsRequired = 2

        self.gestureRecognizers = [panGesture!, pinchGesture!, rotateGesture!, focusGesture!]
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.superview)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.superview)
        
        if recognizer.state == UIGestureRecognizerState.Ended {
            let velocity = recognizer.velocityInView(self.superview)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            let slideFactor = 0.005 * slideMultiplier     //Increase for more of a slide
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            finalPoint.x = min(max(finalPoint.x, self.frame.width / 2), self.superview!.bounds.size.width - self.frame.width / 2)
            finalPoint.y = min(max(finalPoint.y, self.frame.height / 2), self.superview!.bounds.size.height - self.frame.height / 2)
            
            print("final point \n", finalPoint)
            UIView.animateWithDuration(Double(slideFactor * 2),
                                       delay: 0,
                                       options: UIViewAnimationOptions.CurveEaseOut,
                                       animations: { recognizer.view!.center = finalPoint },
                                       completion: nil)
        }
    }
    
    @objc func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformScale(view.transform,
                                                    recognizer.scale, recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformRotate(view.transform, recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    @objc func handleFocus(recogniser: UITapGestureRecognizer) {
        superview?.bringSubviewToFront(self)
    }
}
