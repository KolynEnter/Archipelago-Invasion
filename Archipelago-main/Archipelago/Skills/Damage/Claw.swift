//
//  Claw.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/26/22.
//

struct Claw: Skill {
    var name: String = "Claw"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 2
    var currentCooldown: Int = 0

    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        HPManager().adjustByUserAttackRatio(targets: targets, user: user, attackRatio: 0.5, buffManager: buffManager)
        for target in targets {
            buffManager.addBuffToUnit(buff: Bleeding(carryUnit: target, applierUnit: user), unit: target)
        }
    }
}
