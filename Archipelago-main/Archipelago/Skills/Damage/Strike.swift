//
//  Strike.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/30/22.
//

import SpriteKit

struct Strike: Skill {
    var name: String = "Strike"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 0
    var currentCooldown: Int = 0

    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        HPManager().adjustByUserAttackRatio(targets: targets, user: user, attackRatio: 1, buffManager: buffManager)
        
    }
}
