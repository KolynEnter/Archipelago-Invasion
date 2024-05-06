//
//  Skill.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/30/22.
//

import SpriteKit

protocol Skill {
    var name: String {get}
    var description: String {get}
    var skillType: SkillType {get}
    var range: SpecificationRange {get}
    var isSelfBuff: Bool {get}
    var originalCooldown: Int {get}
    var currentCooldown: Int {get set}
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager)
}
