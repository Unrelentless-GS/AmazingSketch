//
//  AmazingSketchStickerController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 18/08/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchStickerController: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private weak var backgroundImageView: UIImageView? {
        guard let amazingSketchView = self.amazingSketchView else { return nil }
        return amazingSketchView.imageView
    }
    
    private weak var canvasImageView: AmazingSketchDrawingView? {
        guard let amazingSketchView = self.amazingSketchView else { return nil }
        return amazingSketchView.canvasImageView
    }
    
    private weak var scrollView: AmazingSketchScrollView? {
        guard let amazingSketchView = self.amazingSketchView else { return nil }
        return amazingSketchView.scrollView
    }
    
    weak var amazingSketchView: AmazingSketchView?
    var saveCompletionHandler: AmazingSketchSaveCompletionHandler?
    
    private var touchedPoint: CGPoint = CGPointZero
    private var editing: Bool = false
    private var stickers: [UIImageView]?
    
    private weak var presentationViewController: UIViewController?
    
    required init(presentationViewController: UIViewController) {
        super.init()
        self.presentationViewController = presentationViewController
    }
    
    func createGestures() {
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 1
        longPressGesture.addTarget(self, action: #selector(longPressHandler(_:)))
        
        self.amazingSketchView?.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func longPressHandler(handler: UILongPressGestureRecognizer) {
        guard ((presentationViewController?.presentedViewController) == nil) else { return }
        
        touchedPoint = handler.locationInView(self.backgroundImageView)
        let rect = CGRectMake(touchedPoint.x, touchedPoint.y, 20, 20)
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .Popover
        
        imagePicker.popoverPresentationController?.permittedArrowDirections = .Any
        imagePicker.popoverPresentationController?.sourceRect = rect
        imagePicker.popoverPresentationController?.sourceView = self.backgroundImageView
        
        presentationViewController?.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Public
    func stickerHandler(edit: Bool) {
        editing = edit
        self.canvasImageView?.userInteractionEnabled = false
        self.backgroundImageView?.userInteractionEnabled = editing
    }
    
    //MARK: image picker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("did finish picking image")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }

        let imageView = AmazingSketchStickerView(image: image, gestureRecogniserDelegate: scrollView)
        imageView.frame = CGRect(x: touchedPoint.x, y: touchedPoint.y, width: image.size.width, height: image.size.height)
        imageView.contentMode = .ScaleAspectFit
        
        presentationViewController?.dismissViewControllerAnimated(true) { [unowned self] in
            self.stickers?.append(imageView)
        }
        
        backgroundImageView?.addSubview(imageView)
        
        scrollView?.panGestureRecognizer.requireGestureRecognizerToFail(imageView.panGesture!)
        scrollView?.pinchGestureRecognizer!.requireGestureRecognizerToFail(imageView.pinchGesture!)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        presentationViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
