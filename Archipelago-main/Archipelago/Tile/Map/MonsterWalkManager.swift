//
//  MonsterWalker.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/23/23.
//

import SpriteKit

class MonsterWalkManager {
    
    private weak var mapCreator: GameMapCreator?
    private var edgeLength: Int!
    
    init(gameMapCreator: GameMapCreator) {
        self.mapCreator = gameMapCreator
        edgeLength = gameMapCreator.getEdgeLength()
    }
    
    func monstersWalk() {
        guard let mapCreator = mapCreator else {return}
        for i in 0 ..< mapCreator.enemies.count {
            monsterRandomWalk(monsterIndex: i)
        }
    }
    
    private func monsterRandomWalk(monsterIndex: Int) {
        guard let mapCreator = mapCreator else {return}
        let monster: GameUnit = mapCreator.enemies[monsterIndex]
        
        if monster.isChasing && monster.hasChasePath {
            // follow the chase path
            if let firstmove = monster.currentChasePath.first {
                let rowCol = getNewRowCol(direction: firstmove, monsterPosition: monster.position)
                
                let newPosition = getPositionOnMap(row: rowCol.x, col: rowCol.y)
                mapCreator.enemies[monsterIndex].currentChasePath.removeFirst()
                if monster.currentChasePath.isEmpty {
                    mapCreator.enemies[monsterIndex].hasChasePath = false
                }
                mapCreator.enemies[monsterIndex].position = newPosition
                mapCreator.processEnemyHiddenTiles(enemyIndex: monsterIndex)
                checkIfPlayerInSensingRange()
                return
            }
        }
        
        var walkableDirections: [Bool] = [false, false, false, false]
        if !mapCreator.isRotated {
            walkableDirections[0] = nextTileIsWalkable(movingXY: Point2D(x: 0, y: 1), objectLocation: monster.position)
            walkableDirections[1] = nextTileIsWalkable(movingXY: Point2D(x: 0, y: -1), objectLocation: monster.position)
            walkableDirections[2] = nextTileIsWalkable(movingXY: Point2D(x: -1, y: 0), objectLocation: monster.position)
            walkableDirections[3] = nextTileIsWalkable(movingXY: Point2D(x: 1, y: 0), objectLocation: monster.position)
        } else {
            walkableDirections[0] = nextTileIsWalkable(movingXY: Point2D(x: 1, y: 0), objectLocation: monster.position)
            walkableDirections[1] = nextTileIsWalkable(movingXY: Point2D(x: -1, y: 0), objectLocation: monster.position)
            walkableDirections[2] = nextTileIsWalkable(movingXY: Point2D(x: 0, y: 1), objectLocation: monster.position)
            walkableDirections[3] = nextTileIsWalkable(movingXY: Point2D(x: 0, y: -1), objectLocation: monster.position)
        }
        
        var count: Int = 0
        var validIndice = [Int]()
        walkableDirections.forEach {
            if $0 {
                validIndice.append(count)
            }
            count += 1
        }
        if validIndice.isEmpty {return}
        let index = validIndice.randomElement()
        var newPosition: CGPoint!
        let x: CGFloat = monster.position.x
        let y: CGFloat = monster.position.y
        switch index {
        case 0: // up
            newPosition = CGPoint(x: x, y: y + CGFloat(edgeLength))
            break
        case 1: // down
            newPosition = CGPoint(x: x, y: y - CGFloat(edgeLength))
            break
        case 2: // left
            newPosition = CGPoint(x: x  - CGFloat(edgeLength), y: y)
            break
        case 3: // right
            newPosition = CGPoint(x: x  + CGFloat(edgeLength), y: y)
            break
        default:
            break
        }
        mapCreator.enemies[monsterIndex].position = newPosition
        mapCreator.processEnemyHiddenTiles(enemyIndex: monsterIndex)
        checkIfPlayerInSensingRange()
    }
    
    private func getNewRowCol(direction: Point2D, monsterPosition: CGPoint) -> Point2D {
        let trueEnemyRowCol = getRowColOnMap(objectLocation: monsterPosition)
        guard let mapCreator = mapCreator else {return Point2D(x: 0, y: 0)}
        if !mapCreator.isRotated {
            return Point2D(
                x: direction.x + Int(trueEnemyRowCol.x),
                y: direction.y + Int(trueEnemyRowCol.y))
        } else {
            if direction.x == 0 && direction.y == 1 {
                return Point2D(
                    x: 0 + Int(trueEnemyRowCol.x),
                    y: 1 + Int(trueEnemyRowCol.y))
            } else if direction.x == 0 && direction.y == -1 {
                return Point2D(
                    x: 0 + Int(trueEnemyRowCol.x),
                    y: -1 + Int(trueEnemyRowCol.y))
            } else if direction.x == -1 && direction.y == 0 {
                return Point2D(
                    x: -1 + Int(trueEnemyRowCol.x),
                    y: 0 + Int(trueEnemyRowCol.y))
            } else {
                return Point2D(
                    x: 1 + Int(trueEnemyRowCol.x),
                    y: 0 + Int(trueEnemyRowCol.y))
            }
        }
    }
    
    // use a shortest path instead
    private func createChasingPath(enemyIndex: Int) {
        guard let enemy = mapCreator?.enemies[enemyIndex] else {return}
        let trueEnemyRowCol = getRowColOnMap(objectLocation: enemy.position)
        let truePlayerRowCol = getRowColOnMap(objectLocation: mapCreator?.player?.position ?? CGPoint.zero)
        
        let bfs = BFS(matrix: mapCreator?.nonVisualMap)
        
        let path: Stack<Cell> = bfs.shortestPath(start: Point2D(x: trueEnemyRowCol.x, y: trueEnemyRowCol.y),
                                                 end: Point2D(x: truePlayerRowCol.x, y: truePlayerRowCol.y),
                                                 searchingRadius: getRadius(of: enemy))
        if path.isEmpty() {return}
        mapCreator?.enemies[enemyIndex].currentChasePath = pathToActionablePath(path: path)
        mapCreator?.enemies[enemyIndex].hasChasePath = true
    }
    
    private func getRadius(of enemy: GameUnit) -> Int {
        switch enemy.getPreference() {
        case Preference.EMPEROR_MELEE.rawValue,
            Preference.GENERAL_MELEE.rawValue,
            Preference.HUNTER_MELEE.rawValue,
            Preference.KNIGHT_MELEE.rawValue,
            Preference.PAWN_MELEE.rawValue,
            Preference.ROOK_MELEE.rawValue:
            return 3
        case Preference.EMPEROR_RANGE.rawValue,
            Preference.GENERAL_RANGE.rawValue,
            Preference.HUNTER_RANGE.rawValue,
            Preference.KNIGHT_RANGE.rawValue,
            Preference.PAWN_RANGE.rawValue,
            Preference.ROOK_RANGE.rawValue:
            return 4
        default:
            return 0
        }
    }
    
    private func pathToActionablePath(path: Stack<Cell>) -> [Point2D] {
        var stack: Stack<Cell> = path
        var cell = stack.pop()
        var actionablePath = [Point2D]()
        while !stack.isEmpty() {
            let nextCell = stack.pop()
            let direction = Point2D(x: nextCell.x - cell.x, y: nextCell.y - cell.y)
            actionablePath.append(direction)
            cell = nextCell
        }
        return actionablePath
    }
    
    func checkIfPlayerInAttackRange() {
        // need to know which enemy triggered the battle
        guard let mapCreator = mapCreator else {return}
        for i in 0 ..< mapCreator.enemies.count {
            if checkPlayerInAttackRangeHelper(enemyIndex: i) {
                // a battle is triggered
                return
            }
        }
    }
    
    // return true is a battle is triggered, return false to continue searching
    private func checkPlayerInAttackRangeHelper(enemyIndex: Int) -> Bool {
        guard let enemy = mapCreator?.enemies[enemyIndex] else {return false}
        let attackingRange = enemy.getModel().childNode(withName: "attackingRange") as? SKShapeNode
        let x = enemy.position.x + attackingRange!.path!.boundingBox.origin.x
        let y = enemy.position.y + attackingRange!.path!.boundingBox.origin.y
        let attackingRect = CGRect(origin: CGPoint(x: x, y: y), size: (attackingRange?.path?.boundingBox.size)!)
        
        if attackingRect.contains(mapCreator?.player?.position ?? CGPoint.zero) {
            // prepare for segue to Battle Scene
            mapCreator?.setTriggerBattleEnemyIndex(index: enemy.getOriginalAssignedIndex())
            mapCreator?.inBattleNowIsTrue()
            return true
        }
        return false
    }
    
    private func checkIfPlayerInSensingRange() {
        guard let mapCreator = mapCreator else {return}
        for i in 0 ..< mapCreator.enemies.count {
            checkPlayerInSensingRangeHelper(enemyIndex: i)
        }
    }
    
    private func checkPlayerInSensingRangeHelper(enemyIndex: Int) {
        guard let enemy = mapCreator?.enemies[enemyIndex] else {return}
        let sensingRange = enemy.getModel().childNode(withName: "sensingRange") as? SKShapeNode
        let x = enemy.position.x + sensingRange!.path!.boundingBox.origin.x
        let y = enemy.position.y + sensingRange!.path!.boundingBox.origin.y
        let sensingRect = CGRect(origin: CGPoint(x: x, y: y), size: (sensingRange?.path?.boundingBox.size)!)
    
        // if player is being hidden but the monster is not, don't chase
        guard let player = mapCreator?.player else {return}
        if sensingRect.contains(mapCreator?.player?.position ?? CGPoint.zero) &&
            !(player.isBeingHidden && !enemy.isBeingHidden) {
            // everything good, start chasing the player
            mapCreator?.enemies[enemyIndex].isChasing = true
            if !enemy.hasChasePath {
                createChasingPath(enemyIndex: enemyIndex)
            }
        } else {
            // monster lost track of player
            mapCreator?.enemies[enemyIndex].isChasing = false
            mapCreator?.enemies[enemyIndex].hasChasePath = false
            mapCreator?.enemies[enemyIndex].currentChasePath = []
        }
    }
    
    func getPositionOnMap(row: Int, col: Int) -> CGPoint {
        guard let mapCreator = mapCreator else {return CGPoint.zero}
        return mapCreator.getPositionOnMap(row: row, col: col)
    }
    
    func getRowColOnMap(objectLocation: CGPoint) -> Point2D {
        guard let mapCreator = mapCreator else {return Point2D(x: 0, y: 0)}
        return mapCreator.getRowColOnMap(objectLocation: objectLocation)
    }
    
    func nextTileIsWalkable(movingXY: Point2D, objectLocation: CGPoint) -> Bool {
        guard let mapCreator = mapCreator else {return false}
        return mapCreator.nextTileIsWalkable(movingXY: movingXY, objectLocation: objectLocation)
    }
}
