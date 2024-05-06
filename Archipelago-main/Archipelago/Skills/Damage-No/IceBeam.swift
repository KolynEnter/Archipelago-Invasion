//
//  IceBeam.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//

struct IceBeam: Skill {
    var name: String = "IceBeam"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 3
    var currentCooldown: Int = 0

    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        for target in targets {
            buffManager.addBuffToUnit(buff: Frozen(carryUnit: target, applierUnit: user), unit: target)
        }
    }
}
