//
//  ViewController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 10/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var amazingSketch: AmazingSketchView?
    var controller: AmazingSketchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = AmazingSketchController()
        amazingSketch = AmazingSketchView(backgroundImage: UIImage(named: "highResImage")!, controller: controller!)
        amazingSketch!.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(amazingSketch!)
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[amazingSketch]|",
            options: [],
            metrics: nil,
            views: ["amazingSketch" : amazingSketch!]))
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[amazingSketch]|",
            options: [],
            metrics: nil,
            views: ["amazingSketch" : amazingSketch!]))
    }
}
