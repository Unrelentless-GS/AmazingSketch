//
//  AmazingSketchDrawingCanvas.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 19/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchDrawingView: UIImageView {
        
    private weak var controller: AmazingSketchDrawingController?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(controller: AmazingSketchDrawingController?) {
        super.init(image: UIImage())
        self.controller = controller
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        controller?.touchesMoved(self, touches: touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        controller?.touchesEnded(self, touches: touches, withEvent: event)
    }
}
