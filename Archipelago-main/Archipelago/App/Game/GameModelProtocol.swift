//
//  GameModelProtocol.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/10/23.
//

import Foundation

protocol GameModelProtocol {
    // Game
    var nextUpValid: Bool {get set}
    var nextDownValid: Bool {get set}
    var nextLeftValid: Bool {get set}
    var nextRightValid: Bool {get set}
    var inBattleNow: Bool {get set}
    var triggerBattleEnemyIndex: Int {get set}
    var currentLevel: Int {get set}
    var playerUsedEscape: Bool {get set}
    var isOnTown: Bool {get set}
    mutating func goToTown()
    mutating func leaveTown()
    
    // UI
    var gameScene: GameScene! {get}
    var animationFinished: Bool {get set}
    var isMenuOpened: Bool {get set}
    
    mutating func determineValidNextMoves(playerLocation: CGPoint)
}
