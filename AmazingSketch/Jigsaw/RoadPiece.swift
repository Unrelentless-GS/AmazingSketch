//
//  RoadPiece.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 13/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit

struct RoadPiece {
    
    var orientation: JigsawOrientation
    var roadPieceType: RoadPieceType
    
    var connectedSides = Set<JigsawSide>()

    var availableSides: [JigsawSide] {
        var sides = [JigsawSide]()
        
        switch roadPieceType {
        case .Intersection:
            sides = intersectionSides()
        case .TJunction:
            sides = tjunctionSides(orientation)
        case .Straight:
            sides = straightSides(orientation)
        }
        
        return sides
    }
    
    private func intersectionSides() -> [JigsawSide] {
        let availableSides = Array(JigsawSide.allValues.subtract(connectedSides))
        return availableSides
    }
    
    
    private func tjunctionSides(orientation: JigsawOrientation) -> [JigsawSide] {
        let availableSides = JigsawSide.allValues.subtract(connectedSides)
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
        
        availableAllowedSides = Array(availableSides.intersect(allowedSides))
        
        return availableAllowedSides
    }
    
    private func straightSides(orientation: JigsawOrientation) -> [JigsawSide] {
        let availableSides = JigsawSide.allValues.subtract(connectedSides)
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
