//
//  DoubleStrikes.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/26/22.
//

struct DoubleStrikes: Skill {
    var name: String = "Double Strikes"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 2
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        HPManager().adjustByUserAttackRatio(targets: targets, user: user, attackRatio: 2, buffManager: buffManager)
    }
}
