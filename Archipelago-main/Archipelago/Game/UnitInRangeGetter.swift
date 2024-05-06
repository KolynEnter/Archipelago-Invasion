//
//  UnitInRangeChecker.swift
//  Archipelago
//
//  Created by Jianxin Lin on 9/3/22.
//

import SpriteKit

class UnitInRangeGetter {
    
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
    private var allUnits: [Unit]!
    private var attacker: Unit!
    private var target: Unit!
    
    private var upIsOccupied = false
    private var downIsOccupied = false
    private var leftIsOccupied = false
    private var rightIsOccupied = false
    private var upLeftIsOccupied = false
    private var downLeftIsOccupied = false
    private var upRightIsOccupied = false
    private var downRightIsOccupied = false
    
    init(mapCreator: MapCreator) {
        self.edgeLength = mapCreator.getEdgeLength()
        self.rows = mapCreator.getRow()
        self.cols = mapCreator.getCol()
    }
    
    init(mapCreator: MapCreator, predefinedAttackerPos: CGPoint) {
        self.edgeLength = mapCreator.getEdgeLength()
        self.rows = mapCreator.getRow()
        self.cols = mapCreator.getCol()
        self.attackerPosition = predefinedAttackerPos
    }
    
    func getAllHostileUnitsWithinRange(attacker: Unit, allUnits: [Unit]) -> [Unit] {
        let hostileUnits = allUnits.filter {
            $0.isAlly != attacker.isAlly
        }
        let sortedHostileUnits = hostileUnits.sorted {distanceBetween(unit1: attacker, unit2: $0) < distanceBetween(unit1: attacker, unit2: $1)}
        let hostileUnitsInRange = sortedHostileUnits.filter {
            isWithinRange(allUnits: allUnits, attacker: attacker, target: $0)
        }
        upIsOccupied = false
        downIsOccupied = false
        leftIsOccupied = false
        rightIsOccupied = false
        upLeftIsOccupied = false
        downLeftIsOccupied = false
        upRightIsOccupied = false
        downRightIsOccupied = false
        return hostileUnitsInRange.sorted {distanceBetween(unit1: attacker, unit2: $0) < distanceBetween(unit1: attacker, unit2: $1)}
    }
    
    func getAllAllyUnitsWithinRange(user: Unit, allUnits: [Unit]) -> [Unit] {
        let allyUnits = allUnits.filter {
            $0.isAlly == user.isAlly
        }
        let sortedAllyUnits = allyUnits.sorted {distanceBetween(unit1: user, unit2: $0) < distanceBetween(unit1: user, unit2: $1)}
        var allyUnitsInRange = sortedAllyUnits.filter {
            isWithinRange(allUnits: allUnits, attacker: user, target: $0)
        }
        allyUnitsInRange.append(user)
        upIsOccupied = false
        downIsOccupied = false
        leftIsOccupied = false
        rightIsOccupied = false
        upLeftIsOccupied = false
        downLeftIsOccupied = false
        upRightIsOccupied = false
        downRightIsOccupied = false
        return allyUnitsInRange
    }
    
    func getAllUnitsWithinRange(user: Unit, allUnits: [Unit]) -> [Unit] {
        let sortedAllUnits = allUnits.sorted {distanceBetween(unit1: user, unit2: $0) < distanceBetween(unit1: user, unit2: $1)}
        var unitsInRange = sortedAllUnits.filter {
            isWithinRange(allUnits: allUnits, attacker: user, target: $0)
        }
        unitsInRange.append(user)
        upIsOccupied = false
        downIsOccupied = false
        leftIsOccupied = false
        rightIsOccupied = false
        upLeftIsOccupied = false
        downLeftIsOccupied = false
        upRightIsOccupied = false
        downRightIsOccupied = false
        return unitsInRange
    }
    
    private func distanceBetween(unit1: Unit, unit2: Unit) -> CGFloat {
        return unit1.position.manhattanDistance(to: unit2.position)
    }
    
    private func isWithinRange(allUnits: [Unit], attacker: Unit, target: Unit) -> Bool {
        self.allUnits = allUnits
        self.attacker = attacker
        self.target = target
        if self.attackerPosition == nil {
            self.attackerPosition = attacker.position
        }
        self.targetPosition = target.position
        self.region = getTargetUnitRegion()
        leftCols = Int(attackerPosition.x/Double(edgeLength))
        topRows = Int((Double(edgeLength*rows) - attackerPosition.y)/Double(edgeLength))
        rightCols = Int((Double(edgeLength*cols) - attackerPosition.x)/Double(edgeLength))
        downRows = Int(attackerPosition.y/Double(edgeLength))
        
        var result = false
        switch attacker.preference {
        case Preference.PAWN_MELEE.rawValue,
            Preference.EMPEROR_MELEE.rawValue:
            lower = 1
            result = searchTargetUnitByPawn()
            break
        case Preference.PAWN_RANGE.rawValue,
            Preference.EMPEROR_RANGE.rawValue:
            lower = 2
            result = searchTargetUnitByPawn()
            break
        case Preference.KNIGHT_MELEE.rawValue:
            lower = 1
            result = searchTargetUnitByPawn()
            if result {return result}
            result = searchTargetUnitByKnight()
            break
        case Preference.KNIGHT_RANGE.rawValue:
            lower = 2
            result = searchTargetUnitByPawn()
            if result {return result}
            result = searchTargetUnitByKnight()
            break
        case Preference.HUNTER_MELEE.rawValue:
            lower = 1
            result = searchTargetUnitByPawn()
            if result {return result}
            result = searchTargetUnitByHunter()
            break
        case Preference.HUNTER_RANGE.rawValue:
            lower = 2
            result = searchTargetUnitByPawn()
            if result {return result}
            result = searchTargetUnitByHunter()
            break
        case Preference.ROOK_MELEE.rawValue:
            lower = 1
            result = searchTargetUnitByPawn()
            if result {return result}
            result = searchTargetUnitByRook()
            break
        case Preference.ROOK_RANGE.rawValue:
            lower = 2
            result = searchTargetUnitByPawn()
            if result {return result}
            result = searchTargetUnitByRook()
            break
        case Preference.GENERAL_MELEE.rawValue:
            lower = 1
            result = searchTargetUnitByPawn()
            if result {return result}
            result = searchTargetUnitByGeneral()
            break
        case Preference.GENERAL_RANGE.rawValue:
            lower = 2
            result = searchTargetUnitByPawn()
            if result {return result}
            result = searchTargetUnitByGeneral()
            break
        default:
            break
        }
        
        return result
    }
    
    private func searchTargetUnitByPawn() -> Bool {
        var result = false
        switch region {
        case Region.north_lane: // search the top squares
            result = targetOnPawnDirectLine(xRate: 0, yRate: 1)
            if result {upIsOccupied = true}
            break
        case Region.south_lane: // search the bottom squares
            result = targetOnPawnDirectLine(xRate: 0, yRate: -1)
            if result {downIsOccupied = true}
            break
        case Region.east_lane: // search the right squares
            result = targetOnPawnDirectLine(xRate: 1, yRate: 0)
            if result {rightIsOccupied = true}
            break
        case Region.west_lane: // search the left squares
            result = targetOnPawnDirectLine(xRate: -1, yRate: 0)
            if result {leftIsOccupied = true}
            break
        case Region.coordinate_one:
            result = targetOnPawnDiagonalLine(xRate: -1, yRate: 1)
            if result {upLeftIsOccupied = true}
            break
        case Region.coordinate_two:
            result = targetOnPawnDiagonalLine(xRate: 1, yRate: 1)
            if result {upRightIsOccupied = true}
            break
        case Region.coordinate_three:
            result = targetOnPawnDiagonalLine(xRate: -1, yRate: -1)
            if result {downLeftIsOccupied = true}
            break
        case Region.coordinate_four:
            result = targetOnPawnDiagonalLine(xRate: 1, yRate: -1)
            if result {downRightIsOccupied = true}
            break
        default:
            break
        }
        return result
    }
    
    private func targetOnPawnDirectLine(xRate: Int, yRate: Int) -> Bool {
        for i in 1 ..< lower + 1 {
            let possibleSquare = CGPoint(x: attackerPosition.x + Double(xRate*i*edgeLength), y: attackerPosition.y + Double(yRate*i*edgeLength))
            if possibleSquare - targetPosition == CGPoint.zero {return true}
        }
        return false
    }
    
    private func targetOnPawnDiagonalLine(xRate: Int, yRate: Int) -> Bool {
        for i in 1 ..< lower + 1 {
            if i > cols+1 {
                return false
            }
            let possibleSquare = CGPoint(x: attackerPosition.x + Double(xRate*i*edgeLength), y: attackerPosition.y + Double(yRate*i*edgeLength))
            // if it is not the target but any other unit, return false
            let possibleUnits = allUnits.itemAt(position: possibleSquare)
            if possibleUnits != [] {
                if possibleSquare - targetPosition == CGPoint.zero {return true}
            }
        }
        return false
    }
    
    private func searchTargetUnitByKnight() -> Bool {
        var result = false
        
        let points: KeyValuePairs<Int, Int>!
        if lower == 1 {
            points = [-2:-1, -2:1, -1:-2, -1:2, 1:-2, 1:2, 2:-1, 2:1]
        } else {
            points = [-2:-1, -2:1, -1:-2, -1:2, 1:-2, 1:2, 2:-1, 2:1, -2:-3, -2:3, -3:-2, -3:2, 3:-2, 3:2, 2:-3, 2:3]
        }
        for point in points {
            let possibleSquare = CGPoint(x: attackerPosition.x + CGFloat(point.key*edgeLength), y: attackerPosition.y + CGFloat(point.value*edgeLength))
            if possibleSquare - targetPosition == CGPoint.zero {result = true}
        }
        return result
    }
    
    private func searchTargetUnitByHunter() -> Bool {
        var result = false
        switch region {
        case Region.coordinate_one:
            if !upLeftIsOccupied {
                result = targetOnHunterCoordinate(xRate: -1, yRate: 1, cols: leftCols, rows: topRows)
                if result {upLeftIsOccupied = true}
            }
            break
        case Region.coordinate_two:
            if !upRightIsOccupied {
                result = targetOnHunterCoordinate(xRate: 1, yRate: 1, cols: rightCols, rows: topRows)
                if result {upRightIsOccupied = true}
            }
            break
        case Region.coordinate_three:
            if !downLeftIsOccupied {
                result = targetOnHunterCoordinate(xRate: -1, yRate: -1, cols: leftCols, rows: downRows)
                if result {downLeftIsOccupied = true}
            }
            break
        case Region.coordinate_four:
            if !downRightIsOccupied {
                result = targetOnHunterCoordinate(xRate: 1, yRate: -1, cols: rightCols, rows: downRows)
                if result {downRightIsOccupied = true}
            }
            break
        default:
            break
        }
        
        return result
    }
    
    private func targetOnHunterCoordinate(xRate: Int, yRate: Int, cols: Int, rows: Int) -> Bool {
        for i in lower ..< cols + 1 {
            if i > cols+1 {
                return false
            }
            let possibleSquare = CGPoint(x: attackerPosition.x + Double(xRate*i*edgeLength), y: attackerPosition.y + Double(yRate*i*edgeLength))
            // if it is not the target but any other unit, return false
            let possibleUnits = allUnits.itemAt(position: possibleSquare)
            if possibleUnits != [] {
                if possibleSquare - targetPosition == CGPoint.zero {return true}
            }
        }
        return false
    }
    
    private func searchTargetUnitByRook() -> Bool {
        var result = false
        
        switch region {
        case Region.north_lane: // search the top squares
            if !upIsOccupied {
                result = targetOnRookLane(xRate: 0, yRate: 1, lane: topRows)
                if result {upIsOccupied = true}
            }
            break
        case Region.south_lane: // search the bottom squares
            if !downIsOccupied {
                result = targetOnRookLane(xRate: 0, yRate: -1, lane: downRows)
                if result {downIsOccupied = true}
            }
            break
        case Region.east_lane: // search the right squares
            if !rightIsOccupied {
                result = targetOnRookLane(xRate: 1, yRate: 0, lane: rightCols)
                if result {rightIsOccupied = true}
            }
            break
        case Region.west_lane: // search the left squares
            if !leftIsOccupied {
                result = targetOnRookLane(xRate: -1, yRate: 0, lane: leftCols)
                if result {leftIsOccupied = true}
            }
            break
        default:
            break
        }
        return result
    }
    
    private func targetOnRookLane(xRate: Int, yRate: Int, lane: Int) -> Bool {
        for i in lower+1 ..< lane+1 {
            if i > lane+1 {
                return false
            }
            let possibleSquare = CGPoint(x: attackerPosition.x + Double(xRate*i*edgeLength), y: attackerPosition.y + Double(yRate*i*edgeLength))
            // if it is not the target but any other unit, return false
            let possibleUnits = allUnits.itemAt(position: possibleSquare)
            if possibleUnits != [] {
                if possibleSquare - targetPosition == CGPoint.zero {return true}
            }
        }

        return false
    }
    
    private func searchTargetUnitByGeneral() -> Bool {
        var result = searchTargetUnitByHunter()
        if result == false {
            result = searchTargetUnitByRook()
        }
        return result
    }
    
    private func getTargetUnitRegion() -> Int {
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
