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
    var dismissalBlock: JigsawDismissalBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jigsaw = Jigsaw()
        
        createCollectionView()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerNib(UINib(nibName: String(JigsawPieceCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        dismissalBlock?(jigsaw)
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
        let piece = RoadPiece(orientation: .North,
                              roadPieceType: RoadPieceType(rawValue: indexPath.row)!,
                              connectedSides: Set())
        jigsaw?.pieces.append(piece)
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
