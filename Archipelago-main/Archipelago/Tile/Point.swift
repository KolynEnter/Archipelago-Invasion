//
//  Point.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/21/23.
//

struct Point2D: Equatable {
    var x: Int = 0
    var y: Int = 0
}

extension Point2D {
    func manhattanDistance(to: Point2D) -> Int {
        return (abs(x - to.x) + abs(y - to.y))
    }
    
    static func + (a:Point2D, b:Point2D) -> Point2D {
        return Point2D(x: a.x + b.x, y: a.y + b.y)
    }

    static func - (a:Point2D, b:Point2D) -> Point2D {
        return Point2D(x: a.x - b.x, y: a.y - b.y)
    }
}
