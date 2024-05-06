//
//  HPManager.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/25/22.
//

struct HPManager {
    
    init() {
        
    }
    
    func adjustByCurrentHealthPointRatio(targets: [Unit],
                                         user: Unit,
                                         hpRatio: Float,
                                         buffManager: BuffManager,
                                         adjustment: (_ currentHP: Float, _ damage: Float) -> Float) {
        for target in targets {
            let currentHP: Float = target.hpCurrent
            let damage: Float = currentHP * hpRatio
            let newHP = getValidHP(source: adjustment(currentHP, damage), targetMaxHP: target.hpMax)
            setNewCurrentHealthPoint(target: target, newHP: newHP, buffManager: buffManager)
            checkDead(targetCurrentHP: newHP, attacker: user, target: target, buffManager: buffManager)
        }
    }
    
    func adjustByUserAttackRatio(targets: [Unit], user: Unit, attackRatio: Float, buffManager: BuffManager) {
        // check if user has buff that can make its attack fail
        if buffManager.containsBuffMakeCarrierAttackFail(battleIndex: user.battleIndex) {
            buffManager.activateBeforeAttackBuffs(battleIndex: user.battleIndex)
            return
        }
        // Apply before-attack bonus
        var damage: Float = user.atk * attackRatio
        buffManager.activateBeforeAttackBuffs(battleIndex: user.battleIndex)
        damage = DamageManager.damageWithBeforeAttackBuffs(source: damage, bonuser: buffManager.bonusers[user.battleIndex])
        for target in targets {
            let attackFail = buffManager.containsBuffMakeEnemyAttackFail(battleIndex: target.battleIndex)
            // Apply before-damaged buffs of target
            buffManager.activateBeforeDamagedBuffs(battleIndex: target.battleIndex, attacker: user)
            if attackFail {continue}
            let currentHP: Float = target.hpCurrent
            let newHP = getValidHP(source: currentHP - damage, targetMaxHP: target.hpMax)
            setNewCurrentHealthPoint(target: target, newHP: newHP, buffManager: buffManager)
            checkDead(targetCurrentHP: newHP, attacker: user, target: target, buffManager: buffManager)
            // Apply after-damaged buffs of target
            buffManager.activateAfterDamagedBuffs(battleIndex: target.battleIndex, attacker: user)
        }
    }
    
    func healByUserAttackRatio(targets: [Unit], user: Unit, attackRatio: Float, buffManager: BuffManager) {
        // Apply before-healed bonus
        var heal: Float = user.atk * attackRatio
        buffManager.activateBeforeHealedBuffs(battleIndex: user.battleIndex)
        heal = DamageManager.healWithBeforeHealedBuffs(source: heal, bonuser: buffManager.bonusers[user.battleIndex])
        for target in targets {
            let currentHP: Float = target.hpCurrent
            let newHP = getValidHP(source: currentHP + heal, targetMaxHP: target.hpMax)
            setNewCurrentHealthPoint(target: target, newHP: newHP, buffManager: buffManager)
            checkDead(targetCurrentHP: newHP, attacker: user, target: target, buffManager: buffManager)
            // Apply after-healed buffs of target
            buffManager.activateAfterHealedBuffs(battleIndex: target.battleIndex)
        }
    }
    
    // fixed damage will not trigger any buff effects
    func adjustByFixedDamage(targets: [Unit],
                             user: Unit,
                             amount: Float,
                             buffManager: BuffManager,
                             adjustment: (_ currentHP: Float, _ damage: Float) -> Float) {
        for target in targets {
            let currentHP: Float = target.hpCurrent
            let newHP = getValidHP(source: adjustment(currentHP, amount), targetMaxHP: target.hpMax)
            setNewCurrentHealthPoint(target: target, newHP: newHP, buffManager: buffManager)
            checkDead(targetCurrentHP: newHP, attacker: user, target: target, buffManager: buffManager)
        }
    }
    
    func setNewCurrentHealthPoint(target: Unit, newHP: Float, buffManager: BuffManager) {
        target.hpCurrent = newHP
        buffManager.updateHPBar(to: target)
    }
    
    func getValidHP(source: Float, targetMaxHP: Float) -> Float {
        if source >= targetMaxHP {
            return targetMaxHP
        } else if source >= 0.001 {
            return source
        } else {
            return 0
        }
    }
    
    func checkDead(targetCurrentHP: Float, attacker: Unit, target: Unit, buffManager: BuffManager) {
        if targetCurrentHP <= 0.001 && target.isAlive {
            buffManager.addBuffToUnit(buff: Dead(carryUnit: target, applierUnit: attacker), unit: target)
        }
    }
}
