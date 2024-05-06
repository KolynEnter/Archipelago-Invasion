//
//  InventoryTapper.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/14/23.
//


import SpriteKit

class InventoryTapper {
    
    private var inventoryScene: InventoryScene!
    
    func nodesTapped(inventoryScene: InventoryScene, at point: CGPoint) {
        if self.inventoryScene == nil {
            self.inventoryScene = inventoryScene
        }
        tapThings(point: point)
    }
    
    private func tapThings(point: CGPoint) {
        let arr = potentialSelectedNodeArray(point: point)
        
    }
    
    private func potentialSelectedNodeArray(point: CGPoint) -> [Any?] {
        var arr = [Any?]()
        let tappedNodes = inventoryScene.nodes(at: point)
        
        return arr
    }
    
    private func triggerButtonEffect(button: SKLabelNode) {
        let expand = SKAction.scale(to: 1.2, duration: 0.15)
        let shrink = SKAction.scale(to: 1, duration: 0.05)

        let sequence = SKAction.sequence([expand, shrink])
        button.run(sequence)
    }
}
