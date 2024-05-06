//
//  SleepGas.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/6/23.
//

struct SleepGas: Skill {
    var name: String = "Sleep Gas"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 3
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        for target in targets {
            buffManager.addBuffToUnit(buff: Sleeping(carryUnit: target, applierUnit: user), unit: target)
        }
    }
}
