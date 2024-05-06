//
//  Nightmare.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//

struct Nightmare: Skill {
    var name: String = "Nightmare"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 2
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        for target in targets {
            buffManager.addBuffToUnit(buff: Afraid(carryUnit: target, applierUnit: user), unit: target)
        }
    }
}
