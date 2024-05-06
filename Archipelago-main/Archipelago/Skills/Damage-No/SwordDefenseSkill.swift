//
//  SwordDefenseSkill.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//

struct SwordDefenseSkill: Skill {
    var name: String = "Sword Defense"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = true
    var originalCooldown: Int = 3
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        buffManager.addBuffToUnit(buff: SwordDefense(carryUnit: user, applierUnit: user), unit: user)
    }
}
