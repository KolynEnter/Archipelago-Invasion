//
//  BattleModel.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/11/23.
//

import Foundation

struct BattleModel: BattleModelProtocol {
    var battleScene: BattleScene!
    var settingIsOpened: Bool
    var levelEnemyData: LevelEnemyData!
    var triggerBattleEnemyIndex: Int
    var playerUsedEscape: Bool
    var accountingMaterials: [BattleManager.MaterialAndNumber]
    
    init() {
        settingIsOpened = false
        triggerBattleEnemyIndex = -1
        playerUsedEscape = false
        accountingMaterials = [BattleManager.MaterialAndNumber]()
    }
}
