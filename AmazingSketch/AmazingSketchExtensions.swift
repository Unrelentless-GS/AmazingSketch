//
//  AmazingSketchExtensions.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 23/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

extension UIColor{
    
    var red: CGFloat{
        return CGColorGetComponents(self.CGColor)[0]
    }
    
    var green: CGFloat{
        return CGColorGetComponents(self.CGColor)[1]
    }
    
    var blue: CGFloat{
        return CGColorGetComponents(self.CGColor)[2]
    }
    
    var alpha: CGFloat{
        return CGColorGetComponents(self.CGColor)[3]
    }
}

extension UIView {
    
    func renderToImage() -> UIImage? {
        
        UIGraphicsBeginImageContext(self.frame.size);
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        self.layer.renderInContext(context)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image
    }
}
