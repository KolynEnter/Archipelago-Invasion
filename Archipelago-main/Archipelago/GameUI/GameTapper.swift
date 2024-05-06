//
//  GameTapper.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/7/23.
//

import SpriteKit

class GameTapper {
    
    private weak var gameScene: GameScene?
    
    func nodesTapped(gameScene: GameScene, at point: CGPoint) {
        if self.gameScene == nil {
            self.gameScene = gameScene
        }
        tapThings(point: point)
    }
    
    private func tapThings(point: CGPoint) {
        let arr = potentialSelectedNodeArray(point: point)

    }
    
    private func potentialSelectedNodeArray(point: CGPoint) -> [Any?] {
        guard let gameScene = gameScene else {return []}
        var arr = [Any?]()
        let tappedNodes = gameScene.nodes(at: point)
        
        return arr
    }
    
    private func triggerButtonEffect(button: SKNode) {
        let expand = SKAction.scale(to: 1.2, duration: 0.15)
        let shrink = SKAction.scale(to: 1, duration: 0.05)

        let sequence = SKAction.sequence([expand, shrink])
        button.run(sequence)
    }
}
