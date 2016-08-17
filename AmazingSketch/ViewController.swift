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
    
    var editPic: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = AmazingSketchController(imageSavedCompletionHandler: {
            print("image saved")
            self.navigationItem.rightBarButtonItems![0].enabled = true
        })
        amazingSketch = AmazingSketchView(backgroundImage: UIImage(named: "mountains")!, controller: controller!)
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
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editHandler))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveHandler))
        
        self.navigationItem.rightBarButtonItems = [saveButton, editButton]
    }
    
    func editHandler() {
        editPic = !editPic
        controller?.editHandler(editPic)
    }
    
    func saveHandler() {
        navigationItem.rightBarButtonItems![0].enabled = false
        controller?.saveHandler()
    }
}
