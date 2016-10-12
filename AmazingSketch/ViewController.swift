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
    var drawingController: AmazingSketchDrawingController?
    var stickerController: AmazingSketchStickerController?
    
    var editPic: Bool = false
    var editSticker: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingController = AmazingSketchDrawingController(imageSavedCompletionHandler: { [unowned self] in
            print("image saved")
            self.navigationItem.rightBarButtonItems![0].enabled = true
        })
        drawingController?.lineColour = UIColor.purpleColor()
        drawingController?.mapPresentationViewController = self
        
        stickerController = AmazingSketchStickerController(presentationViewController: self)
        
        amazingSketch = AmazingSketchView(
            backgroundImage: UIImage(named: "mountains")!,
            drawingController: drawingController!,
            stickerController: stickerController)
        
        amazingSketch!.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(amazingSketch!)
        addConstraints()
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(editHandler))
        let stickerButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(stickerHandler))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveHandler))
        let mapButton = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(mapHandler))
        
        self.navigationItem.rightBarButtonItems = [saveButton, editButton, stickerButton, mapButton]
    }
    
    private func addConstraints() {
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
    
    func stickerHandler() {
        editSticker = !editSticker
        stickerController?.stickerHandler(editSticker)
    }
    
    func editHandler() {
        editPic = !editPic
        drawingController?.editHandler(editPic)
    }
    
    func saveHandler() {
        navigationItem.rightBarButtonItems![0].enabled = false
        drawingController?.saveHandler()
    }
    
    func mapHandler() {
        drawingController?.mapPresentationHandler()
    }
}
