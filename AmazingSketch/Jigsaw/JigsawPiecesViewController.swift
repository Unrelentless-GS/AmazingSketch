//
//  JigsawPiecesViewController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class JigsawPiecesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    
    lazy var images: [UIImage] = {
        var images = [UIImage]()
        
        for roadPiece in RoadPieceType.allValues {
            if let image = UIImage(named: roadPiece.imageName) {
                images.append(image)
            }
        }
        
        return images
    }()
    
    var jigsaw: Jigsaw?
    var direction: UISwipeGestureRecognizerDirection?
    var coordinate: JigsawCoordinate?
    var dismissalBlock: JigsawDismissalBlock?
    
    convenience init(jigsaw: Jigsaw?, direction: UISwipeGestureRecognizerDirection?, fromCoordinate coordinate: JigsawCoordinate?) {
        self.init()
        self.jigsaw = jigsaw
        self.direction = direction
        self.coordinate = coordinate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if jigsaw == nil { jigsaw = Jigsaw() }
        
        createCollectionView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerNib(UINib(nibName: String(JigsawPieceCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func createCollectionView() {
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)

        let horizConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|",
                                                                              options: [],
                                                                              metrics: nil,
                                                                              views: ["collectionView": collectionView])
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[collectionView]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["collectionView": collectionView])
        NSLayoutConstraint.activateConstraints(horizConstraints)
        NSLayoutConstraint.activateConstraints(verticalConstraints)
    }
    
    private func layout() -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        return layout
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        var piece: RoadPiece
        
        if jigsaw?.pieces.count == 0 {
            let coordinate = JigsawCoordinate(x: 0, y: 0)
            piece = RoadPiece(orientation: .North,
                                  roadPieceType: RoadPieceType(rawValue: indexPath.row)!,
                                  connectedSides: Set())
            jigsaw?.pieces[coordinate] = piece
        } else {
            let connectedSide = JigsawSide.swipeGestureMap[direction!]
            
            let y = direction! == .Left || direction! == .Right ? self.coordinate!.y : direction! == .Up ? self.coordinate!.y + 1 : self.coordinate!.y - 1
            let x = direction! == .Up || direction! == .Down ? self.coordinate!.x : direction! == .Right ? self.coordinate!.x + 1 : self.coordinate!.x - 1
            
            let coordinate = JigsawCoordinate(x: x, y: y)
            piece = RoadPiece(orientation: .North,
                                  roadPieceType: RoadPieceType(rawValue: indexPath.row)!,
                                  connectedSides: Set<JigsawSide>(arrayLiteral: connectedSide!))
            jigsaw?.pieces[coordinate] = piece
        }
        
        dismissalBlock?(jigsaw, piece)

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RoadPieceType.allValues.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let image = images[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! JigsawPieceCollectionViewCell
        cell.customizeCell(image)
        
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
