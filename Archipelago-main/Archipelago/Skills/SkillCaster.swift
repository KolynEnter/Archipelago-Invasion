//
//  SkillCaster.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/3/23.
//

import SpriteKit

class SkillCaster {
    
    private weak var battleManager: BattleManager?
    
    init(battleManager: BattleManager) {
        self.battleManager = battleManager
    }
    
    func cast(skill: Skill, user: Unit, targets: [Unit], mapCreator: MapCreator) {
        switch(skill.skillType) {
        case .SOLO:
            activateSolo(skill: skill, user: user, targets: targets)
            return
        case .SOLO_ALLY:
            activateSolo(skill: skill, user: user, targets: targets)
            return
        case .SOLO_ENEMY:
            activateSolo(skill: skill, user: user, targets: targets)
            return
        case .MULT:
            activateMult(skill: skill, user: user, mapCreator: mapCreator)
            return
        case .MULT_ALLY:
            activateMultAlly(skill: skill, user: user, mapCreator: mapCreator)
            return
        case .MULT_ENEMY:
            activateMultEnemy(skill: skill, user: user, mapCreator: mapCreator)
        }
    }
    
    private func activateSolo(skill: Skill, user: Unit, targets: [Unit]) {
        guard let battleManager = battleManager else {return}
        skill.activate(user: user, targets: targets, buffManager: battleManager.buffManager)
    }
    
    private func activateMult(skill: Skill, user: Unit, mapCreator: MapCreator) {
        guard let battleManager = battleManager else {return}
        let units = battleManager.units
        if skill.range == .LOCAL {
            let unitInRangeGetter: UnitInRangeGetter = UnitInRangeGetter(mapCreator: mapCreator, predefinedAttackerPos: user.position)
            let inRangeUnits = unitInRangeGetter.getAllUnitsWithinRange(user: user, allUnits: units)
            skill.activate(user: user, targets: inRangeUnits, buffManager: battleManager.buffManager)
        } else {
            skill.activate(user: user, targets: units, buffManager: battleManager.buffManager)
        }
    }
    
    private func activateMultAlly(skill: Skill, user: Unit, mapCreator: MapCreator) {
        guard let battleManager = battleManager else {return}
        let units = battleManager.units
        if skill.range == .LOCAL {
            let unitInRangeGetter: UnitInRangeGetter = UnitInRangeGetter(mapCreator: mapCreator, predefinedAttackerPos: user.position)
            let inRangeUnits = unitInRangeGetter.getAllAllyUnitsWithinRange(user: user, allUnits: units)
            skill.activate(user: user, targets: inRangeUnits, buffManager: battleManager.buffManager)
        } else {
            let targets = units.filter {$0.isAlly == user.isAlly}
            skill.activate(user: user, targets: targets, buffManager: battleManager.buffManager)
        }
    }
    
    private func activateMultEnemy(skill: Skill, user: Unit, mapCreator: MapCreator) {
        guard let battleManager = battleManager else {return}
        let units = battleManager.units
        if skill.range == .LOCAL {
            let unitInRangeGetter: UnitInRangeGetter = UnitInRangeGetter(mapCreator: mapCreator, predefinedAttackerPos: user.position)
            let inRangeUnits = unitInRangeGetter.getAllHostileUnitsWithinRange(attacker: user, allUnits: units)
            skill.activate(user: user, targets: inRangeUnits, buffManager: battleManager.buffManager)
        } else {
            let targets = units.filter {$0.isAlly != user.isAlly}
            skill.activate(user: user, targets: targets, buffManager: battleManager.buffManager)
        }
    }
}
