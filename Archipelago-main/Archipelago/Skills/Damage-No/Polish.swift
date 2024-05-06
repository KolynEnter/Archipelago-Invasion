//
//  Polish.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//

struct Polish: Skill {
    var name: String = "Polish"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = true
    var originalCooldown: Int = 2
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        buffManager.addBuffToUnit(buff: Polishing(carryUnit: user, applierUnit: user), unit: user)
    }
}
