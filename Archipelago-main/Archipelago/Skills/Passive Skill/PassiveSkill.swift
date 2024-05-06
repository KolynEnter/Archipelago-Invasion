//
//  PassiveSkill.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/19/23.
//

import SpriteKit

protocol PassiveSkill: Skill {
    var isActivatedAllTime: Bool {get set}
    var triggerOnlyOnceInLifeTime: Bool {get}
    var triggerType: BuffType {get}
    var icon: SKSpriteNode {get}
}
