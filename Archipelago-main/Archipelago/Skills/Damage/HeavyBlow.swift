//
//  HeavyBlow.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//

struct HeavyBlow: Skill {
    var name: String = "Heavy Blow"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 4
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        HPManager().adjustByUserAttackRatio(targets: targets, user: user, attackRatio: 1, buffManager: buffManager)
        for target in targets {
            buffManager.addBuffToUnit(buff: Stunned(carryUnit: target, applierUnit: user), unit: target)
        }
    }
}
