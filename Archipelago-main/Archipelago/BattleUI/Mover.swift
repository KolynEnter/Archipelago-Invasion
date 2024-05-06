//
//  Mover.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/25/22.
//

import SpriteKit

class Mover {
    
    weak var battleScene: BattleScene?
    private var selectionMarker: SKSpriteNode!
    private var moveSquares = [SKSpriteNode]()
    private var edgeLength = 0
    private var counter = 0
    private var mapCreator = MapCreator()
    private var selectedUnit: Unit?
    private var maxHigh = 0
    private var upIsOccupied = false
    private var downIsOccupied = false
    private var leftIsOccupied = false
    private var rightIsOccupied = false
    private var upLeftIsOccupied = false
    private var downLeftIsOccupied = false
    private var upRightIsOccupied = false
    private var downRightIsOccupied = false
    private var moveSquareColor: UIColor {
        guard let selectedUnit = selectedUnit else {return UIColor.lightGray}
        if !selectedUnit.isAlive {
            return UIColor.lightGray
        }
        if selectedUnit.isAlly {
            return UIColor.systemBlue
        } else {
            return UIColor.cyan
        }
    }
    
    init(battleScene: BattleScene, mapCreator: MapCreator) {
        self.battleScene = battleScene
        self.mapCreator = mapCreator
        self.edgeLength = mapCreator.getEdgeLength()
        selectedUnit = nil
        selectionMarker = SKSpriteNode(imageNamed: "SelectionMarker")
        selectionMarker.texture?.filteringMode = .nearest
        selectionMarker.zPosition = zPositions.selectionMarker
        battleScene.addChild(selectionMarker)
        hideSelectinMarker()
        
        maxHigh = Int(sqrt(Double(2*mapCreator.getRow()*mapCreator.getCol())))
        let high = 26 + 4 * maxHigh + mapCreator.getRow() + mapCreator.getCol()
        
        for _ in 0 ..< Int(high) {
            //let moveSquare = SKSpriteNode(color: UIColor.white, size: CGSize(width: edgeLength, height: edgeLength))
            let moveSquare = SKSpriteNode(imageNamed: "TilePaint")
            moveSquare.addChild(SKSpriteNode(imageNamed: "TilePaintBorder"))
            moveSquare.colorBlendFactor = 1
            moveSquare.alpha = 0
            moveSquare.name = "move"
            moveSquare.zPosition = zPositions.selectionMarker
            moveSquares.append(moveSquare)
            battleScene.addChild(moveSquare)
        }
    }
    
    func showMoveOptions() {
        guard let battleScene = battleScene else {return}
        guard let selectedUnit = battleScene.getSelectedItem() as? Unit else {return}
        
        self.selectedUnit = selectedUnit
        switch selectedUnit.preference {
        case Preference.PAWN_MELEE.rawValue,
            Preference.EMPEROR_MELEE.rawValue:
            pawnMelee()
            break
        case Preference.PAWN_RANGE.rawValue,
            Preference.EMPEROR_RANGE.rawValue:
            pawnRange()
            break
        case Preference.KNIGHT_MELEE.rawValue:
            pawnMelee()
            knightMelee()
            break
        case Preference.KNIGHT_RANGE.rawValue:
            pawnRange()
            knightRange()
            break
        case Preference.HUNTER_MELEE.rawValue:
            pawnMelee()
            hunterMove(lower: 2)
            break
        case Preference.HUNTER_RANGE.rawValue:
            pawnRange()
            hunterMove(lower: 3)
            break
        case Preference.ROOK_MELEE.rawValue:
            pawnMelee()
            rookMove(lower: 2)
            break
        case Preference.ROOK_RANGE.rawValue:
            pawnRange()
            rookMove(lower: 3)
            break
        case Preference.GENERAL_MELEE.rawValue:
            pawnMelee()
            generalMove(lower: 2)
            break
        case Preference.GENERAL_RANGE.rawValue:
            pawnRange()
            generalMove(lower: 3)
            break
        default:
            break
        }
        counter = 0
        upIsOccupied = false
        downIsOccupied = false
        leftIsOccupied = false
        rightIsOccupied = false
        upLeftIsOccupied = false
        downLeftIsOccupied = false
        upRightIsOccupied = false
        downRightIsOccupied = false
    }
    
    func pawnMelee() {
        for row in -1 ..< 2 {
            for col in -1 ..< 2 {
                tileProcess(col: col, row: row)
                counter += 1
            }
        }
    }
    
    func pawnRange() {
        for row in -2 ..< 3 {
            for col in -2 ..< 3 {
                tileProcess(col: col, row: row)
                counter += 1
            }
        }
    }
    
    func knightMelee() {
        let points: KeyValuePairs = [-2:-1, -2:1, -1:-2, -1:2, 1:-2, 1:2, 2:-1, 2:1]
        for point in points {
            tileProcess(col: point.key, row: point.value)
            counter += 1
        }
    }
    
    func knightRange() {
        let points: KeyValuePairs = [-3:-2, -3:2, -2:-3, -2:3, 2:-3, 2:3, 3:-2, 3:2]
        for point in points {
            tileProcess(col: point.key, row: point.value)
            counter += 1
        }
    }
    
    func hunterMove(lower: Int) {
        for i in lower ..< maxHigh {
            if !upLeftIsOccupied {
                tileProcess(col: i, row: i)
                counter += 1
            }
            if !downRightIsOccupied {
                tileProcess(col: -i, row: -i)
                counter += 1
            }
            if !downLeftIsOccupied {
                tileProcess(col: i, row: -i)
                counter += 1
            }
            if !upRightIsOccupied {
                tileProcess(col: -i, row: i)
                counter += 1
            }
        }
    }
    
    func rookMove(lower: Int) {
        for i in lower ..< maxHigh {
            if !leftIsOccupied {
                tileProcess(col: i, row: 0)
                counter += 1
            }
            if !rightIsOccupied {
                tileProcess(col: -i, row: 0)
                counter += 1
            }
            if !downIsOccupied {
                tileProcess(col: 0, row: -i)
                counter += 1
            }
            if !upIsOccupied {
                tileProcess(col: 0, row: i)
                counter += 1
            }
        }
    }
    
    func generalMove(lower: Int) {
        hunterMove(lower: lower)
        rookMove(lower: lower)
    }
    
    func tileProcess(col: Int, row: Int) {
        guard let selectedUnit = selectedUnit else {return}
        guard let battleScene = battleScene else {return}
        let squareX = selectedUnit.position.x + CGFloat(col * edgeLength)
        let squareY = selectedUnit.position.y + CGFloat(row * edgeLength)
        let squarePosition = CGPoint(x: squareX, y: squareY)
        if !mapCreator.squarePositionIsInBoard(position: squarePosition) {
            return
        }
        let currentUnits = battleScene.battleManager.units.itemAt(position: squarePosition)
        
        if !currentUnits.isEmpty {
            // check if this unit is hindering the path
            let xDifference = selectedUnit.position.x - squarePosition.x
            let yDifference = selectedUnit.position.y - squarePosition.y
            
            if Int(xDifference) == 0 {
                // hindering up: having the same x and unit1's y is greater than unit2
                if yDifference < 0 {
                    upIsOccupied = true
                    processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
                    return
                } else if yDifference > 0 {
                    // hindering down: having the same x and unit1's y is smaller than unit2
                    downIsOccupied = true
                    processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
                    return
                }
            }
            
            if Int(yDifference) == 0 {
                // hindering left: having the same y and unit1's x is greater than unit2
                if xDifference < 0 {
                    leftIsOccupied = true
                    processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
                    return
                } else if xDifference > 0 {
                    // hindering right: havign the same y and unit1's x is smaller than unit2
                    rightIsOccupied = true
                    processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
                    return
                }
            }
            
            // check diagonal
            if abs(Int(xDifference)) == abs(Int(yDifference)) {
                if xDifference < 0 && yDifference < 0 {
                    upLeftIsOccupied = true
                    processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
                    return
                } else if xDifference > 0 && yDifference < 0 {
                    upRightIsOccupied = true
                    processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
                    return
                } else if xDifference < 0 && yDifference > 0 {
                    downLeftIsOccupied = true
                    processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
                    return
                } else if xDifference > 0 && yDifference > 0 {
                    downRightIsOccupied = true
                    processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
                    return
                }
            }
            
            if currentUnits[0].battleIndex != selectedUnit.battleIndex {
                processUnitSquare(square: moveSquares[counter], unit: currentUnits[0], position: squarePosition)
            }
        } else {
            processMoveSquare(square: moveSquares[counter], position: squarePosition)
        }
    }
    
    private func processMoveSquare(square: SKSpriteNode, position: CGPoint) {
        square.color = moveSquareColor
        square.position = position
        square.alpha = 0.7
    }
    
    private func processUnitSquare(square: SKSpriteNode, unit: Unit, position: CGPoint) {
        square.color = unitSquareColor(currentUnit: unit)
        square.position = position
        square.alpha = 0.7
    }
    
    private func unitSquareColor(currentUnit: Unit) -> UIColor {
        guard let selectedUnit = selectedUnit else {return UIColor.gray}
        if !selectedUnit.isAlive {
            return UIColor.gray
        }
        if selectedUnit.isAlly == currentUnit.isAlly {
            return COLOR_ALLY
        } else {
            return COLOR_ENEMY
        }
    }
    
    func hideMoveOptions() {
        moveSquares.forEach {
            $0.alpha = 0
        }
    }
    
    func showSelectionMarker() {
        guard let battleScene = battleScene else {return}
        guard let item = battleScene.getSelectedItem() as? Unit else {return}
        if item.isAlly {
            selectionMarker.texture = SKTexture(imageNamed: "SelectionMarkerAlly")
        } else {
            selectionMarker.texture = SKTexture(imageNamed: "SelectionMarkerEnemy")
        }
        selectionMarker.removeAllActions()
        
        selectionMarker.position = item.position
        selectionMarker.alpha = 1
        
        let rotate = SKAction.rotate(byAngle: -CGFloat.pi, duration: 2)
        let repeatForever = SKAction.repeatForever(rotate)
        selectionMarker.run(repeatForever)
        
        var goalX = item.size.width*0.7
        var goalY = item.size.height*0.7
        let shrink = SKAction.resize(toWidth: goalX, height: goalY, duration: 1)
        
        goalX = item.size.width
        goalY = item.size.height
        let expand = SKAction.resize(toWidth: goalX, height: goalY, duration: 1)
        
        let sequence = SKAction.sequence([shrink, expand])
        let repeatSequence = SKAction.repeatForever(sequence)
        selectionMarker.run(repeatSequence)
    }
    
    func hideSelectinMarker() {
        selectionMarker.removeAllActions()
        selectionMarker.alpha = 0
    }
}
