//
//  GameModel.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/10/23.
//

import Foundation

struct GameModel: GameModelProtocol {
    var nextUpValid: Bool
    var nextDownValid: Bool
    var nextLeftValid: Bool
    var nextRightValid: Bool
    var inBattleNow: Bool
    var triggerBattleEnemyIndex: Int
    var currentLevel: Int
    var playerUsedEscape: Bool
    var isOnTown: Bool
    var gameScene: GameScene!
    var animationFinished: Bool
    var isMenuOpened: Bool

    init() {
        self.isOnTown = false
        self.nextUpValid = true
        self.nextDownValid = true
        self.nextLeftValid = true
        self.nextRightValid = true
        self.animationFinished = true
        self.inBattleNow = false
        self.isMenuOpened = false
        self.playerUsedEscape = false
        self.triggerBattleEnemyIndex = -1
        self.currentLevel = -1
    }
    
    mutating func goToTown() {
        isOnTown = true
    }
    
    mutating func leaveTown() {
        isOnTown = false
    }
    
    mutating func determineValidNextMoves(playerLocation: CGPoint) {
        guard let player: GameUnit = gameScene.mapCreator.player else {return}
        if !gameScene.mapCreator.isRotated {
            nextUpValid = gameScene.mapCreator.nextTileIsWalkable(movingXY: Point2D(x: 0, y: 1), objectLocation: player.position)
            nextDownValid = gameScene.mapCreator.nextTileIsWalkable(movingXY: Point2D(x: 0, y: -1), objectLocation: player.position)
            nextLeftValid = gameScene.mapCreator.nextTileIsWalkable(movingXY: Point2D(x: -1, y: 0), objectLocation: player.position)
            nextRightValid = gameScene.mapCreator.nextTileIsWalkable(movingXY: Point2D(x: 1, y: 0), objectLocation: player.position)
        } else {
            nextUpValid = gameScene.mapCreator.nextTileIsWalkable(movingXY: Point2D(x: 1, y: 0), objectLocation: player.position)
            nextDownValid = gameScene.mapCreator.nextTileIsWalkable(movingXY: Point2D(x: -1, y: 0), objectLocation: player.position)
            nextLeftValid = gameScene.mapCreator.nextTileIsWalkable(movingXY: Point2D(x: 0, y: 1), objectLocation: player.position)
            nextRightValid = gameScene.mapCreator.nextTileIsWalkable(movingXY: Point2D(x: 0, y: -1), objectLocation: player.position)
        }
    }
}
