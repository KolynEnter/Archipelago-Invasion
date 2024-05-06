//
//  Power.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/19/23.
//

import SpriteKit

/*
 
    user's atk + 20% at all time
 
 */

struct Power: PassiveSkill {
    var icon: SKSpriteNode = SKSpriteNode(imageNamed: "Raged")
    var isActivatedAllTime: Bool = true
    var triggerOnlyOnceInLifeTime: Bool = true
    var triggerType: BuffType = .SPECIAL
    var name: String = "Power"
    var description: String = "Add 20% atk power."
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = true
    var originalCooldown: Int = 0
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        user.atk = user.atk * 1.2
    }
}
