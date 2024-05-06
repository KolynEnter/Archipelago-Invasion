//
//  MindControl.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/15/23.
//

import SpriteKit

/*
 
 Gain target enemy's control for the next new turn
 After use, player immediately starts a new turn
 but can only use the controlled unit
 and will trigger all-before turn buffs
 The controlled unit can move and attack
 
 */

struct MindControl: Skill {
    var name: String = "Mind Control"
    var description: String = ""
    var skillType: SkillType = .SOLO_ENEMY
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 8
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        buffManager.addBuffToUnit(buff: MindControlled(carryUnit: targets[0], applierUnit: user), unit: targets[0])
        buffManager.giveControlledUnitTurn(controlledUnitBattleIndex: targets[0].battleIndex)
    }
}
