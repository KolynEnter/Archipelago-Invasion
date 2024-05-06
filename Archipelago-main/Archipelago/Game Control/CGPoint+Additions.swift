//
//  CGPoint+Additions.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/23/22.
//

import UIKit
import SpriteKit

extension CGPoint {
    func manhattanDistance(to: CGPoint) -> CGFloat {
        return (abs(x - to.x) + abs(y - to.y))
    }
    
    static func + (a:CGPoint, b:CGPoint) -> CGPoint {
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }

    static func - (a:CGPoint, b:CGPoint) -> CGPoint {
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
}

extension Array where Element: SKSpriteNode {
    func itemAt(position: CGPoint) -> [Element] {
        return filter {
            let diffX = abs($0.position.x - position.x)
            let diffY = abs($0.position.y - position.y)
            return diffX + diffY < 20
        }
    }
}
