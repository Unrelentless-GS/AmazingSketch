//
//  JigsawDefinitions.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

enum JigsawOrientation: Int {
    case North
    case East
    case South
    case West
}

enum JigsawSide {
    case North
    case South
    case East
    case West
    
    static var allValues: Set<JigsawSide> {
        return [
            .North,
            .South,
            .East,
            .West]
    }
}

enum RoadPieceType: Int {
    case Intersection = 0
    case TJunction
    case Straight
    
    var imageName: String {
        switch self {
        case .Intersection:
            return "intersection"
        case .TJunction:
            return "t-junction"
        case .Straight:
            return "straight"
        }
    }
    
    var image: UIImage? {
        return UIImage(named: self.imageName)
    }
    
    static var allValues: [RoadPieceType] {
        return [
            .Intersection,
            .TJunction,
            .Straight]
    }
}

typealias JigsawPieceHandler = (RoadPiece) -> ()
typealias JigsawDismissalBlock = (Jigsaw?) -> ()
