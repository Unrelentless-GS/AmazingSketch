//
//  RoadPiece.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

enum JigsawOrientation {
    case North
    case South
    case East
    case West
}

enum JigsawSide {
    case North
    case South
    case East
    case West
    
    static var allSides: [JigsawSide] {
        return [
            .North,
            .South,
            .East,
            .West]
    }
}

enum RoadPieceType {
    case Intersection
    case TJunction(orientation: JigsawOrientation)
    case Straight(orientation: JigsawOrientation)
    
    var rawValue: String {
        switch self {
        case .Intersection:
            return "intersection"
        case .TJunction(orientation: _):
            return "t-junction"
        case .Straight(orientation: _):
            return "straight"
        }
    }
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

struct RoadPiece {
    
    var orientation: JigsawOrientation
    var connectedSides: Set<JigsawSide>
    var roadPieceType: RoadPieceType
    
    var availableSides: [JigsawSide] {
        var sides = [JigsawSide]()
        
        switch roadPieceType {
        case .Intersection:
            sides = intersectionSides()
        case .TJunction(orientation: orientation):
            sides = tjunctionSides(orientation)
        case .Straight(orientation: orientation):
            sides = sraightSides(orientation)
        }
        
        return sides
    }
    
    
    private func intersectionSides() -> [JigsawSide] {
        let availableSides = Array(connectedSides.subtract(JigsawSide.allSides))
        return availableSides
    }
    
    
    private func tjunctionSides(orientation: JigsawOrientation) -> [JigsawSide] {
        let availableSides = connectedSides.intersect(JigsawSide.allSides)
        var allowedSides = [JigsawSide]()
        var availableAllowedSides = [JigsawSide]()
        
        switch orientation {
        case .North:
            allowedSides = [.North, .East, .West]
        case .South:
            allowedSides = [.South, .East, .West]
        case .East:
            allowedSides = [.North, .South, .East]
        case .West:
            allowedSides = [.North, .South, .West]
        }
        
        availableAllowedSides = Array(availableSides.subtract(allowedSides))
        
        return availableAllowedSides
        
    }
    
    private func sraightSides(orientation: JigsawOrientation) -> [JigsawSide] {
        let availableSides = connectedSides.subtract(JigsawSide.allSides)
        var allowedSides = [JigsawSide]()
        var availableAllowedSides = [JigsawSide]()
        
        switch orientation {
        case .North, .South:
            allowedSides = [.North, .South]
        case .East, .West:
            allowedSides = [.East, .West]
        }
        
        availableAllowedSides = Array(availableSides.intersect(allowedSides))
        
        return availableAllowedSides
    }
}
