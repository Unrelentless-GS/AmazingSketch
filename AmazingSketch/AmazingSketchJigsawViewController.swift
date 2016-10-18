//
//  AmazingSketchJigsawViewController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchJigsawViewController: UIViewController, JigsawPieceViewDelegate {
    
    var setHandler: AmazingSketchSetHandler?
    var hasJigsaw = false
    var touchedPoint: CGPoint!
    var jigsaw = Jigsaw()
    var jigsawPieces = [JigsawPieceView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 1
        longPressGesture.addTarget(self, action: #selector(longPressHandler(_:)))
        
        self.view?.addGestureRecognizer(longPressGesture)
        
        let setButton = UIBarButtonItem(title: "Set", style: .Plain, target: self, action: #selector(jigsawSetHandler))
        let dismissButton = UIBarButtonItem(title: "Dismiss", style: .Plain, target: self, action: #selector(dismissHandler))
        
        self.navigationItem.rightBarButtonItems = [setButton]
        self.navigationItem.leftBarButtonItems = [dismissButton]
    }
    
    
    //MARK: map callbakcs
    
    @objc private func jigsawSetHandler(button: UIBarButtonItem) {
        
        jigsawPieces.forEach{$0.removeOverlays()}
        
        if let image = self.view.renderToImage() {
            setHandler?(image: image)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func dismissHandler(button: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func longPressHandler(handler: UILongPressGestureRecognizer) {
        guard self.presentedViewController == nil else { return }
        guard self.hasJigsaw == false else { return }
        
        touchedPoint = handler.locationInView(self.view)
        let rect = CGRect(x: touchedPoint.x, y: touchedPoint.y, width: 20, height: 20)
        
        let piecePicker = JigsawPiecesViewController()
        
        piecePicker.modalPresentationStyle = .Popover
        piecePicker.dismissalBlock = { [unowned self] jigsaw, piece in
            guard let jigsaw = jigsaw else { return }
            guard let roadPiece = piece else { return }
            self.jigsaw = jigsaw
            
            let jigsawPiece = JigsawPieceView(roadPiece: roadPiece, delegate: self)
            jigsawPiece.center = self.touchedPoint
            self.view.addSubview(jigsawPiece)
            self.jigsawPieces.append(jigsawPiece)
            self.hasJigsaw = true
        }
        
        piecePicker.popoverPresentationController?.permittedArrowDirections = .Any
        piecePicker.popoverPresentationController?.sourceRect = rect
        piecePicker.popoverPresentationController?.sourceView = self.view
        
        self.presentViewController(piecePicker, animated: true, completion: nil)
    }
    
    //MARK: JigsawPieceViewDelegate
    func jigsawPieceView(jigsawPieceView: JigsawPieceView, swipedWithDirection direction: UISwipeGestureRecognizerDirection) {
        let coordinate = jigsaw.pieces.filter{$0.1 == jigsawPieceView.roadPiece}.first?.0
        let piecePickerViewController = JigsawPiecesViewController(jigsaw: jigsaw, direction: direction, fromCoordinate: coordinate)
        
        piecePickerViewController.dismissalBlock = { [unowned self, jigsawPieceView, direction] newJigsaw, piece in
            guard let roadPiece = piece else { return }
            
            let x = direction == .Down || direction == .Up ? jigsawPieceView.center.x : jigsawPieceView.center.x + (direction == .Right ? jigsawPieceView.frame.height : (-jigsawPieceView.frame.width))
            let y = direction == .Right || direction == .Left ? jigsawPieceView.center.y : jigsawPieceView.center.y + (direction == .Down ? jigsawPieceView.frame.height : (-jigsawPieceView.frame.height))
            
            let jigsawPiece = JigsawPieceView(roadPiece: roadPiece, delegate: self)
            jigsawPiece.center = CGPoint(x: x, y: y)
            self.view.addSubview(jigsawPiece)
            
            self.jigsaw = newJigsaw!
            self.jigsawPieces.append(jigsawPiece)
            self.updateJigsaw(withPiece: roadPiece)
        }
        
        piecePickerViewController.modalPresentationStyle = .Popover
        piecePickerViewController.popoverPresentationController?.permittedArrowDirections = .Any
        piecePickerViewController.popoverPresentationController?.sourceRect = jigsawPieceView.frame
        piecePickerViewController.popoverPresentationController?.sourceView = self.view
        
        self.presentViewController(piecePickerViewController, animated: true, completion: nil)
    }
    
    private func updateJigsaw(withPiece roadPiece: RoadPiece) {
        let coordinate = roadPiece.coordinate
        
        let upPiece = jigsaw.pieces.filter{$0.0.y == coordinate.y + 1 && $0.0.x == coordinate.x}.first
        let downPiece = jigsaw.pieces.filter{$0.0.y == coordinate.y - 1 && $0.0.x == coordinate.x}.first
        let leftPiece = jigsaw.pieces.filter{$0.0.x == coordinate.x - 1 && $0.0.y == coordinate.y}.first
        let rightPiece = jigsaw.pieces.filter{$0.0.x == coordinate.x + 1 && $0.0.y == coordinate.y}.first
        
        if let upPiece = upPiece {
            var newPiece = upPiece.1
            newPiece.connectedSides.unionInPlace([.South])
            jigsaw.pieces[upPiece.0] = newPiece
            updateViewsWith(newPiece)
        }
        
        if let downPiece = downPiece {
            var newPiece = downPiece.1
            newPiece.connectedSides.unionInPlace([.North])
            jigsaw.pieces[downPiece.0] = newPiece
            updateViewsWith(newPiece)
        }
        
        if let leftPiece = leftPiece {
            var newPiece = leftPiece.1
            newPiece.connectedSides.unionInPlace([.East])
            jigsaw.pieces[leftPiece.0] = newPiece
            updateViewsWith(newPiece)
        }
        
        if let rightPiece = rightPiece {
            var newPiece = rightPiece.1
            newPiece.connectedSides.unionInPlace([.West])
            jigsaw.pieces[rightPiece.0] = newPiece
            updateViewsWith(newPiece)
        }
    }
    
    private func updateViewsWith(newPiece: RoadPiece) {
        let jigsawPieceView = jigsawPieces.filter{$0.roadPiece.coordinate == newPiece.coordinate}.first
        let index = jigsawPieces.indexOf(jigsawPieceView!)
        
        jigsawPieceView?.roadPiece = newPiece
        jigsawPieces[index!] = jigsawPieceView!
    }
}
