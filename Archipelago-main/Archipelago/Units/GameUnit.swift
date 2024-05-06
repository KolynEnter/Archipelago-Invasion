//
//  GameUnit.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/28/23.
//

// Unit pieces on the game board

import SpriteKit

struct GameUnit {
    var isChasing = false
    var hasChasePath = false
    var currentChasePath = [Point2D]()
    var position: CGPoint = CGPoint.zero {
        didSet {
            if !isNonActionMove {
                model.run(SKAction.move(to: position, duration: TimeController.regularCameraMovement))
            }
            isNonActionMove = false
        }
    }
    var isBeingHidden = false
    private var model: SKSpriteNode
    private var preference: Int
    private var isNonActionMove = false
    private var originalAssignedIndex: Int
    
    init(unitTextureName: String, isAlly: Bool, preference: Int, originalAssignedIndex: Int) {
        self.model = SKSpriteNode(imageNamed: unitTextureName)
        self.model.zPosition = zPositions.unit
        var base: SKSpriteNode
        if isAlly {
            base = SKSpriteNode(imageNamed: "SelectionMarkerAlly")
        } else {
            base = SKSpriteNode(imageNamed: "SelectionMarkerEnemy")
        }
        model.addChild(base)
        self.preference = preference
        self.originalAssignedIndex = originalAssignedIndex
    }
    
    mutating func nonActionMove(to position: CGPoint) {
        isNonActionMove = true
        self.position = position
        self.model.position = position
    }
    
    func getModel() -> SKSpriteNode {
        return model
    }
    
    func getPreference() -> Int {
        return preference
    }
    
    func getOriginalAssignedIndex() -> Int {
        return originalAssignedIndex
    }
}
