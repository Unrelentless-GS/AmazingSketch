//
//  AmazingSketchScrollView.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 19/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    var editing = false
    
    init() {
        super.init(frame: CGRectZero)
        self.canCancelContentTouches = false
//        self.delaysContentTouches = false
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        print("\n", gestureRecognizer)
        print("\n", otherGestureRecognizer)
        print("\n****************************")
        
        return true
    }
}
