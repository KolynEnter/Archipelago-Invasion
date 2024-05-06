//
//  BattleModelProtocol.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/11/23.
//

import Foundation

protocol BattleModelProtocol {
    var battleScene: BattleScene! {get}
    var settingIsOpened: Bool {get set}
    var levelEnemyData: LevelEnemyData! {get set}
    var triggerBattleEnemyIndex: Int {get set}
    var playerUsedEscape: Bool {get set}
    var accountingMaterials: [BattleManager.MaterialAndNumber] {get}
}
