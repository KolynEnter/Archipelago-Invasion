//
//  DamageManager.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//

struct DamageManager {
    static func damageWithBeforeAttackBuffs(source: Float, bonuser: Bonuser) -> Float {
        return bonuser.applyBonus(stat: .ATTACK, source: source)
    }
    static func healWithBeforeHealedBuffs(source: Float, bonuser: Bonuser) -> Float {
        return bonuser.applyBonus(stat: .HEAL, source: source)
    }
}
