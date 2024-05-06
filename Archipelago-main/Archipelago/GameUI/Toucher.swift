//
//  Toucher.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/10/23.
//

import SpriteKit

class GameSceneToucher {
    weak var gameScene: GameScene?
    let tapper = GameTapper()
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
    }
    
    func nodesTapped(at point: CGPoint) {
        guard let gameScene = gameScene else {return}
        tapper.nodesTapped(gameScene: gameScene, at: point)
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let gameScene = gameScene else {return}
        guard let touch = touches.first else {return}
        gameScene.lastTouch = touch.location(in: gameScene.view)
        gameScene.originalTouch = gameScene.lastTouch
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let gameScene = gameScene else {return}
        guard let touch = touches.first else {return}
        
        //touchesMoved(touches, with: event)
        let distance = gameScene.originalTouch.manhattanDistance(to: gameScene.lastTouch)
        if distance < 44 {
            nodesTapped(at: touch.location(in: gameScene))
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        guard let gameScene = gameScene else {return}
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: gameScene.view)
        
        // set a camera boundary
        let mapCreator = gameScene.mapCreator
        let el: CGFloat = CGFloat(mapCreator.getEdgeLength())
        let row: CGFloat = CGFloat(mapCreator.getRow())
        let col: CGFloat = CGFloat(mapCreator.getCol())
        
        let cameraNode = gameScene.cameraNode!
        let newX = cameraNode.position.x + cameraNode.xScale*2*(gameScene.lastTouch.x - touchLocation.x)
        let newY = cameraNode.position.y + cameraNode.xScale*2*(touchLocation.y - gameScene.lastTouch.y)
        if newX > 0 && newX < el * row && newY > 0 && newY < el * col {
            cameraNode.position = CGPoint(x: newX, y: newY)
        }
            
        gameScene.lastTouch = touchLocation
         */
    }
}
