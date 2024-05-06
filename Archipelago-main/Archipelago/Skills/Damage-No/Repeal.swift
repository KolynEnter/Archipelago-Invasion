//
//  Repeal.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//


struct Repeal: Skill {
    var name: String = "Repeal"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 0
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        user.cannotMove = false
        for i in 0 ..< buffManager.unitBuffs[user.battleIndex].buffs.count {
            buffManager.unitBuffs[user.battleIndex].buffs[i].numOfRepealRequiredSubtractOne()
            buffManager.unitBuffs[user.battleIndex].buffs[i].sustainabilitySubtractOne()
        }
        buffManager.updateCharacterNode(to: user)
    }
}
