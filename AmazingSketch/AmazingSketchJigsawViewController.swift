//
//  AmazingSketchJigsawViewController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchJigsawViewController: UIViewController {

    var touchedPoint: CGPoint!
    var jigsaw = Jigsaw()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 1
        longPressGesture.addTarget(self, action: #selector(longPressHandler(_:)))
        
        self.view?.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func longPressHandler(handler: UILongPressGestureRecognizer) {
        guard self.presentedViewController == nil else { return }
        
        touchedPoint = handler.locationInView(self.view)
        let rect = CGRectMake(touchedPoint.x, touchedPoint.y, 20, 20)
        
        let piecePicker = JigsawPiecesViewController(nibName: String(JigsawPiecesViewController), bundle: nil)
        piecePicker.modalPresentationStyle = .Popover
        
        piecePicker.popoverPresentationController?.permittedArrowDirections = .Any
        piecePicker.popoverPresentationController?.sourceRect = rect
        piecePicker.popoverPresentationController?.sourceView = self.view
        
        self.presentViewController(piecePicker, animated: true, completion: nil)
    }
}