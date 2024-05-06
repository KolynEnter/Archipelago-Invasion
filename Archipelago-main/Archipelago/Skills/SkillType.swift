//
//  SkillType.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/3/23.
//

enum SkillType {
    case SOLO
    case SOLO_ALLY
    case SOLO_ENEMY
    case MULT
    case MULT_ALLY // cannot be applied to Enemy
    case MULT_ENEMY // cannot be applied to Ally
}
