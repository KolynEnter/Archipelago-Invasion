//
//  SoulStrike.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/3/23.
//

import SpriteKit

// deal 0.5 * user atk damage to all enemies

struct SoulStrike: Skill {
    var name: String = "Soul Strike"
    var description: String = ""
    var skillType: SkillType = .MULT_ENEMY
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 3
    var currentCooldown: Int = 0

    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        HPManager().adjustByUserAttackRatio(targets: targets, user: user, attackRatio: 0.5, buffManager: buffManager)
    }
}
