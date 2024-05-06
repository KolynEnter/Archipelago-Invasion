//
//  AutoMoveDeterminator.swift
//  Archipelago
//
//  Created by Jianxin Lin on 9/3/22.
//

import SpriteKit

class AutoMoveDeterminator {
    
    private let edgeLength: Int!
    private let rows: Int!
    private let cols: Int!
    private var attackerPosition: CGPoint!
    private var targetPosition: CGPoint!
    private var region: Int!
    private var lower: Int!
    private var leftCols: Int!
    private var topRows: Int!
    private var rightCols: Int!
    private var downRows: Int!
    
    init(mapCreator: MapCreator) {
        self.edgeLength = mapCreator.getEdgeLength()
        self.rows = mapCreator.getRow()
        self.cols = mapCreator.getCol()
    }
    
    func getDesiredPositionToMove(attacker: Unit, target: Unit) -> CGPoint {
        var result = CGPoint(x: 100, y: 100)
        self.attackerPosition = attacker.position
        self.targetPosition = target.position
        self.region = getHostileUnitRegion(attackerPosition: attackerPosition, targetPosition: targetPosition)
        leftCols = Int(attackerPosition.x/Double(edgeLength))
        topRows = Int((Double(edgeLength*rows) - attackerPosition.y)/Double(edgeLength))
        rightCols = Int((Double(edgeLength*cols) - attackerPosition.x)/Double(edgeLength))
        downRows = Int(attackerPosition.y/Double(edgeLength))
        
        switch attacker.preference {
        case Preference.PAWN_MELEE.rawValue,
            Preference.EMPEROR_MELEE.rawValue:
            lower = 1
            result = findMoveForPawn()
            break
        case Preference.PAWN_RANGE.rawValue,
            Preference.EMPEROR_RANGE.rawValue:
            lower = 2
            result = findMoveForPawn()
            break
        case Preference.KNIGHT_MELEE.rawValue:
            lower = 1
            result = findMoveForKnight()
            break
        case Preference.KNIGHT_RANGE.rawValue:
            lower = 2
            result = findMoveForKnight()
            break
        case Preference.HUNTER_MELEE.rawValue:
            lower = 1
            result = findMoveForHunter()
            break
        case Preference.HUNTER_RANGE.rawValue:
            lower = 2
            result = findMoveForHunter()
            break
        case Preference.ROOK_MELEE.rawValue:
            lower = 1
            result = findMoveForRook()
            break
        case Preference.ROOK_RANGE.rawValue:
            lower = 2
            result = findMoveForRook()
            break
        case Preference.GENERAL_MELEE.rawValue:
            lower = 1
            result = findMoveGeneral()
            break
        case Preference.GENERAL_RANGE.rawValue:
            lower = 2
            result = findMoveGeneral()
            break
        default:
            break
        }
        
        return result
    }
    
    private func findMoveForPawn() -> CGPoint {
        var result = CGPoint(x: 100, y: 100)
        
        switch region {
        case Region.north_lane:
            result = pawnForLane(lane: topRows, xRate: 0, yRate: 1)
            break
        case Region.south_lane:
            result = pawnForLane(lane: downRows, xRate: 0, yRate: -1)
            break
        case Region.west_lane:
            result = pawnForLane(lane: leftCols, xRate: -1, yRate: 0)
            break
        case Region.east_lane:
            result = pawnForLane(lane: rightCols, xRate: 1, yRate: 0)
            break
        case Region.coordinate_one:
            result = pawnForTwoLanes(row: topRows, col: leftCols, xRate: -1, yRate: 1)
            break
        case Region.coordinate_two:
            result = pawnForTwoLanes(row: topRows, col: rightCols, xRate: 1, yRate: 1)
            break
        case Region.coordinate_three:
            result = pawnForTwoLanes(row: downRows, col: leftCols, xRate: -1, yRate: -1)
            break
        case Region.coordinate_four:
            result = pawnForTwoLanes(row: downRows, col: rightCols, xRate: 1, yRate: -1)
            break
        default:
            break
        }
        
        return result
    }
    
    private func pawnForLane(lane: Int, xRate: Int, yRate: Int) -> CGPoint {
        var value = lower
        if lower > lane {
            value = lane
        }
        return CGPoint(x: attackerPosition.x + Double(xRate*value!*edgeLength), y: attackerPosition.y + Double(yRate*value!*edgeLength))
    }
    
    private func pawnForTwoLanes(row: Int, col: Int, xRate: Int, yRate: Int) -> CGPoint {
        var value1 = lower
        var value2 = lower
        if lower > row {
            value2 = row
        }
        if lower > col {
            value1 = col
        }
        
        return CGPoint(x: attackerPosition.x + Double(xRate*value1!*edgeLength), y: attackerPosition.y + Double(yRate*value2!*edgeLength))
    }
    
    private func findMoveForKnight() -> CGPoint {
        // If a desired slot is occupied by a friendly unit, choose the other one instead (unlikely to occur for now)
        var result = findMoveForPawn()
        
        switch region {
        case Region.north_lane:
            let northLeft = knightForLane(lane1: topRows, lane2: leftCols, xRate: -lower, yRate: lower+1)
            let northRight = knightForLane(lane1: topRows, lane2: rightCols, xRate: lower, yRate: lower+1)
            let possiblePosition = (northLeft.manhattanDistance(to: targetPosition) < northRight.manhattanDistance(to: targetPosition) && northLeft != targetPosition) ? northLeft : northRight
            if possiblePosition != attackerPosition {result = possiblePosition}
            break
        case Region.south_lane:
            let southLeft = knightForLane(lane1: downRows, lane2: leftCols, xRate: -lower, yRate: -(lower+1))
            let southRight = knightForLane(lane1: downRows, lane2: rightCols, xRate: lower, yRate: -(lower+1))
            let possiblePosition = (southLeft.manhattanDistance(to: targetPosition) < southRight.manhattanDistance(to: targetPosition) && southLeft != targetPosition) ? southLeft : southRight
            if possiblePosition != attackerPosition {result = possiblePosition}
            break
        case Region.west_lane:
            let westTop = knightForLane(lane1: leftCols, lane2: topRows, xRate: -(lower+1), yRate: lower)
            let westDown = knightForLane(lane1: leftCols, lane2: downRows, xRate: -(lower+1), yRate: -lower)
            let possiblePosition = (westTop.manhattanDistance(to: targetPosition) < westDown.manhattanDistance(to: targetPosition) && westTop != targetPosition) ? westTop : westDown
            if possiblePosition != attackerPosition {result = possiblePosition}
            break
        case Region.east_lane:
            let eastTop = knightForLane(lane1: rightCols, lane2: topRows, xRate: lower+1, yRate: lower)
            let eastDown = knightForLane(lane1: rightCols, lane2: downRows, xRate: lower+1, yRate: -lower)
            let possiblePosition = (eastTop.manhattanDistance(to: targetPosition) < eastDown.manhattanDistance(to: targetPosition) && eastTop != targetPosition) ? eastTop : eastDown
            if possiblePosition != attackerPosition {result = possiblePosition}
            break
        case Region.coordinate_one:
            let northLeft = knightForLane(lane1: topRows, lane2: leftCols, xRate: -lower, yRate: lower+1)
            let westTop = knightForLane(lane1: leftCols, lane2: topRows, xRate: -(lower+1), yRate: lower)
            let possiblePosition = (northLeft.manhattanDistance(to: targetPosition) < westTop.manhattanDistance(to: targetPosition) && northLeft != targetPosition) ? northLeft : westTop
            if possiblePosition != attackerPosition {result = possiblePosition}
            break
        case Region.coordinate_two:
            let northRight = knightForLane(lane1: topRows, lane2: rightCols, xRate: lower, yRate: lower+1)
            let eastTop = knightForLane(lane1: rightCols, lane2: topRows, xRate: lower+1, yRate: lower)
            let possiblePosition = (northRight.manhattanDistance(to: targetPosition) < eastTop.manhattanDistance(to: targetPosition) && northRight != targetPosition) ? northRight : eastTop
            if possiblePosition != attackerPosition {result = possiblePosition}
            break
        case Region.coordinate_three:
            let southLeft = knightForLane(lane1: downRows, lane2: leftCols, xRate: -lower, yRate: -(lower+1))
            let westDown = knightForLane(lane1: leftCols, lane2: downRows, xRate: -(lower+1), yRate: -lower)
            let possiblePosition = (southLeft.manhattanDistance(to: targetPosition) < westDown.manhattanDistance(to: targetPosition) && southLeft != targetPosition) ? southLeft : westDown
            if possiblePosition != attackerPosition {result = possiblePosition}
            break
        case Region.coordinate_four:
            let southRight = knightForLane(lane1: downRows, lane2: rightCols, xRate: lower, yRate: -(lower+1))
            let eastDown = knightForLane(lane1: rightCols, lane2: downRows, xRate: lower+1, yRate: -lower)
            let possiblePosition = (southRight.manhattanDistance(to: targetPosition) < eastDown.manhattanDistance(to: targetPosition) && southRight != targetPosition) ? southRight : eastDown
            if possiblePosition != attackerPosition {result = possiblePosition}
            break
        default:
            break
        }
        
        return result
    }
    
    private func knightForLane(lane1: Int, lane2: Int, xRate: Int, yRate:Int) -> CGPoint{
        if lower < lane1 && lower-1 < lane2 {
            return CGPoint(x: attackerPosition.x + Double(xRate*edgeLength), y: attackerPosition.y + Double(yRate*edgeLength))
        }
        return attackerPosition
    }
    
    private func findMoveForHunter() -> CGPoint {
        var result = findMoveForPawn()
        
        switch region {
        case Region.north_lane: // upLeft + upRight
            let one = hunterForDiagonalLanes(cols: leftCols, rows: topRows, xRate: -1, yRate: 1)
            let two = hunterForDiagonalLanes(cols: rightCols, rows: topRows, xRate: 1, yRate: 1)
            result = (one.manhattanDistance(to: targetPosition) < two.manhattanDistance(to: targetPosition) && one != targetPosition) ? one : two
            break
        case Region.south_lane: // downLeft + downRight
            let three = hunterForDiagonalLanes(cols: leftCols, rows: downRows, xRate: -1, yRate: -1)
            let four = hunterForDiagonalLanes(cols: rightCols, rows: downRows, xRate: 1, yRate: -1)
            result = (three.manhattanDistance(to: targetPosition) < four.manhattanDistance(to: targetPosition) && three != targetPosition) ? three : four
            break
        case Region.west_lane: // upLeft + downLeft
            let one = hunterForDiagonalLanes(cols: leftCols, rows: topRows, xRate: -1, yRate: 1)
            let three = hunterForDiagonalLanes(cols: leftCols, rows: downRows, xRate: -1, yRate: -1)
            result = (one.manhattanDistance(to: targetPosition) < three.manhattanDistance(to: targetPosition) && one != targetPosition) ? one : three
            break
        case Region.east_lane: // upRight + downRight
            let two = hunterForDiagonalLanes(cols: rightCols, rows: topRows, xRate: 1, yRate: 1)
            let four = hunterForDiagonalLanes(cols: rightCols, rows: downRows, xRate: 1, yRate: -1)
            result = (two.manhattanDistance(to: targetPosition) < four.manhattanDistance(to: targetPosition) && two != targetPosition) ? two : four
            break
        case Region.coordinate_one:
            result = hunterForDiagonalLanes(cols: leftCols, rows: topRows, xRate: -1, yRate: 1)
            break
        case Region.coordinate_two:
            result = hunterForDiagonalLanes(cols: rightCols, rows: topRows, xRate: 1, yRate: 1)
            break
        case Region.coordinate_three:
            result = hunterForDiagonalLanes(cols: leftCols, rows: downRows, xRate: -1, yRate: -1)
            break
        case Region.coordinate_four:
            result = hunterForDiagonalLanes(cols: rightCols, rows: downRows, xRate: 1, yRate: -1)
            break
        default:
            break
        }
        
        return result
    }
    
    private func hunterForDiagonalLanes(cols: Int, rows: Int, xRate: Int, yRate: Int) -> CGPoint {
        var result = CGPoint(x: 100, y: 100)
        var closestValue = CGFloat.infinity
        for i in lower ..< cols + lower {
            var x = i
            if x > cols {
                x = cols
            }
            for j in lower ..< rows + lower {
                var y = j
                if y > rows {
                    y = rows
                }
                if i == j {
                    let possiblePosition = CGPoint(x: attackerPosition.x + Double(xRate*x*edgeLength), y: attackerPosition.y + Double(yRate*y*edgeLength))
                    let distance = possiblePosition.manhattanDistance(to: targetPosition)
                    if distance < closestValue && distance != 0 {
                        closestValue = distance
                        result = possiblePosition
                    }
                }
            }
        }
        return result
    }
    
    private func findMoveForRook() -> CGPoint {
        var result = findMoveForPawn()
        
        switch region {
        case Region.north_lane:
            result = rookForDirectLanes(lane: topRows, xRate: 0, yRate: 1)
            break
        case Region.south_lane:
            result = rookForDirectLanes(lane: downRows, xRate: 0, yRate: -1)
            break
        case Region.west_lane:
            result = rookForDirectLanes(lane: leftCols, xRate: -1, yRate: 0)
            break
        case Region.east_lane:
            result = rookForDirectLanes(lane: rightCols, xRate: 1, yRate: 0)
            break
        case Region.coordinate_one: // north + west
            let north = rookForDirectLanes(lane: topRows, xRate: 0, yRate: 1)
            let west = rookForDirectLanes(lane: leftCols, xRate: -1, yRate: 0)
            result = (north.manhattanDistance(to: targetPosition) < west.manhattanDistance(to: targetPosition) && north != targetPosition) ? north : west
            break
        case Region.coordinate_two: // north + east
            let north = rookForDirectLanes(lane: topRows, xRate: 0, yRate: 1)
            let east = rookForDirectLanes(lane: rightCols, xRate: 1, yRate: 0)
            result = (north.manhattanDistance(to: targetPosition) < east.manhattanDistance(to: targetPosition) && north != targetPosition) ? north : east
            break
        case Region.coordinate_three: // west + south
            let west = rookForDirectLanes(lane: leftCols, xRate: -1, yRate: 0)
            let south = rookForDirectLanes(lane: downRows, xRate: 0, yRate: -1)
            result = (south.manhattanDistance(to: targetPosition) < west.manhattanDistance(to: targetPosition) && south != targetPosition) ? south : west
            break
        case Region.coordinate_four: // east + south
            let east = rookForDirectLanes(lane: rightCols, xRate: 1, yRate: 0)
            let south = rookForDirectLanes(lane: downRows, xRate: 0, yRate: -1)
            result = (south.manhattanDistance(to: targetPosition) < east.manhattanDistance(to: targetPosition) && south != targetPosition) ? south : east
            break
        default:
            break
        }
        
        return result
    }
    
    private func rookForDirectLanes(lane: Int, xRate: Int, yRate: Int) -> CGPoint {
        var closestValue = CGFloat.infinity
        var result = CGPoint(x: 100, y: 100)
        for i in lower ..< lane + lower {
            var value = i
            if value > lane {
                value = lane
            }
            let possiblePosition = CGPoint(x: attackerPosition.x + Double(xRate*value*edgeLength), y: attackerPosition.y + Double(yRate*value*edgeLength))
            let distance = possiblePosition.manhattanDistance(to: targetPosition)
            if distance < closestValue && distance != 0 {
                closestValue = distance
                result = possiblePosition
            }
        }
        return result
    }
    
    private func findMoveGeneral() -> CGPoint {
        let resultHunter = findMoveForHunter()
        let resultRook = findMoveForRook()
        return (resultHunter.manhattanDistance(to: targetPosition) <= resultRook.manhattanDistance(to: targetPosition)) ? resultHunter : resultRook
    }
    
    private func getHostileUnitRegion(attackerPosition: CGPoint, targetPosition: CGPoint) -> Int {
        if attackerPosition.x == targetPosition.x && attackerPosition.y < targetPosition.y {
            return Region.north_lane
        }
        if attackerPosition.x == targetPosition.x && attackerPosition.y > targetPosition.y {
            return Region.south_lane
        }
        if attackerPosition.x > targetPosition.x && attackerPosition.y == targetPosition.y {
            return Region.west_lane
        }
        if attackerPosition.x < targetPosition.x && attackerPosition.y == targetPosition.y {
            return Region.east_lane
        }
        if attackerPosition.x > targetPosition.x && attackerPosition.y < targetPosition.y {
            return Region.coordinate_one
        }
        if attackerPosition.x < targetPosition.x && attackerPosition.y > targetPosition.y {
            return Region.coordinate_four
        }
        if attackerPosition.x > targetPosition.x && attackerPosition.y > targetPosition.y {
            return Region.coordinate_three
        }
        if attackerPosition.x < targetPosition.x && attackerPosition.y < targetPosition.y {
            return Region.coordinate_two
        }

        return 0 // invalid
    }
}
