//
//  MagicLight.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/6/23.
//

struct MagicLight: Skill {
    var name: String = "Magic Light"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 3
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        
        for target in targets {
            buffManager.addBuffToUnit(buff: Blind(carryUnit: target, applierUnit: user), unit: target)
        }
    }
}
