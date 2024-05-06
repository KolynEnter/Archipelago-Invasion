//
//  Restore.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/15/23.
//

import SpriteKit

struct Restore: Skill {
    var name: String = "Restore"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 4
    var currentCooldown: Int = 0

    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        HPManager().healByUserAttackRatio(targets: targets, user: user, attackRatio: 1, buffManager: buffManager)
    }
}
