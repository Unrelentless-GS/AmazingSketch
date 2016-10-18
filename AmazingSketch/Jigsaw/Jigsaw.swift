//
//  Jigsaw.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

struct Jigsaw: Equatable {
    var pieces = [JigsawCoordinate: RoadPiece]()
}

struct JigsawCoordinate: Hashable {
    var x: Int
    var y: Int

    var hashValue: Int {
        let hashAttempt = "\(x)\(y)".hashValue
        return hashAttempt
    }
}

func ==(lhs: Jigsaw, rhs: Jigsaw) -> Bool {
    return lhs.pieces == rhs.pieces
}

func ==(lhs: JigsawCoordinate, rhs: JigsawCoordinate) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
