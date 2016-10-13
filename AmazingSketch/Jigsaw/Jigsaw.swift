//
//  Jigsaw.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

class Jigsaw {
    
    var pieceUpdateHandler: JigsawPieceHandler
    
    init(handler: JigsawPieceHandler) {
        pieceUpdateHandler = handler
    }
    
    var pieces = [RoadPiece]() {
        didSet {
            guard let roadPiece = pieces.last else { return }
            pieceUpdateHandler(roadPiece)
        }
    }
}
