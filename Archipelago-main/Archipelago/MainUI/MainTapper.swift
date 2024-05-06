//
//  MainTapper.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/7/23.
//

import SpriteKit

class MainTapper {
    
    private var mainScene: MainScene!
    
    func nodesTapped(mainScene: MainScene, at point: CGPoint) {
        if self.mainScene == nil {
            self.mainScene = mainScene
        }
        tapThings(point: point)
    }
    
    private func tapThings(point: CGPoint) {
        let arr = potentialSelectedNodeArray(point: point)
        
    }
    
    private func potentialSelectedNodeArray(point: CGPoint) -> [Any?] {
        var arr = [Any?]()
        let tappedNodes = mainScene.nodes(at: point)
        
        return arr
    }
    
    private func triggerButtonEffect(button: SKLabelNode) {
        let expand = SKAction.scale(to: 1.2, duration: 0.15)
        let shrink = SKAction.scale(to: 1, duration: 0.05)

        let sequence = SKAction.sequence([expand, shrink])
        button.run(sequence)
    }
}
