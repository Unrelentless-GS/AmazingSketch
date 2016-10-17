//
//  AmazingSketchJigsawViewController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class AmazingSketchJigsawViewController: UIViewController, JigsawPieceViewDelegate {
    
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
            
            //            let connectedDirection = JigsawSide.swipeGestureMap[direction]
            
            let jigsawPiece = JigsawPieceView(roadPiece: roadPiece, delegate: self)
            jigsawPiece.center = CGPoint(x: x, y: y)
            //            if let connectedDirection = connectedDirection {
            //                jigsawPiece.roadPiece.connectedSides.insert(connectedDirection)
            //            }
            self.view.addSubview(jigsawPiece)
            
            self.jigsaw = newJigsaw!
        }
        
        piecePickerViewController.modalPresentationStyle = .Popover
        piecePickerViewController.popoverPresentationController?.permittedArrowDirections = .Any
        piecePickerViewController.popoverPresentationController?.sourceRect = jigsawPieceView.frame
        piecePickerViewController.popoverPresentationController?.sourceView = self.view
        
        self.presentViewController(piecePickerViewController, animated: true, completion: nil)    }
    
}
