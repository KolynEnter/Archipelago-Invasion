//
//  Toucher2.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/27/23.
//

import SpriteKit

class BattleSceneToucher {
    private weak var battleScene: BattleScene?
    private var tapper: BattleTapper!
    
    init(battleScene: BattleScene) {
        self.battleScene = battleScene
        tapper = BattleTapper(battleScene: battleScene)
    }
    
    func nodesTapped(at point: CGPoint) {
        guard let battleScene = battleScene else {return}
        tapper.nodesTapped(battleScene: battleScene, at: point)
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let battleScene = battleScene else {return}
        guard let viewController = battleScene.viewController else {return}
        if viewController.controller.settingIsOpened() {return}
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: battleScene.view)
        
        // set a camera boundary
        let mapCreator = battleScene.mapCreator
        let el: CGFloat = CGFloat(mapCreator.getEdgeLength())
        let row: CGFloat = CGFloat(mapCreator.getRow())
        let col: CGFloat = CGFloat(mapCreator.getCol())
            
        let cameraNode = battleScene.cameraNode!
        let lastTouch = battleScene.lastTouch
        let newX = cameraNode.position.x + cameraNode.xScale*2*(lastTouch.x - touchLocation.x)
        let newY = cameraNode.position.y + cameraNode.xScale*2*(touchLocation.y - lastTouch.y)
        if newX > 0 && newX < el * row && newY > 0 && newY < el * col {
            battleScene.cameraNode.position = CGPoint(x: newX, y: newY)
        }
            
        battleScene.lastTouch = touchLocation
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let battleScene = battleScene else {return}
        guard let viewController = battleScene.viewController else {return}
        if viewController.controller.settingIsOpened() {return}
        guard let touch = touches.first else {return}
        touchesMoved(touches, with: event)
        let distance = battleScene.originalTouch.manhattanDistance(to: battleScene.lastTouch)
        if distance < 44 {
            nodesTapped(at: touch.location(in: battleScene))
        }
    }
    
    func getSelectedItem() -> SKSpriteNode? {
        return tapper.selectedItem
    }
    
    func setSelectedItem(to item: SKSpriteNode) {
        tapper.selectedItem = item
    }
    
    func setSelectedItemToNull() {
        tapper.selectedItem = nil
    }
    
    func getCurrentTurn() -> Int {
        return tapper.turnController.currentTurn
    }
    
    func setCurrentTurn(to turn: Int) {
        tapper.turnController.currentTurn = turn
    }
    
    func setControlledUnitBattleIndex(to index: Int) {
        tapper.turnController.controlledUnitBattleIndex = index
    }
}
