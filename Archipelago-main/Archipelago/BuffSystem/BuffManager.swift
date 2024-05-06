//
//  BuffManager.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/23/22.
//

// Buff manager manages buffs of all units during the battle

import SpriteKit
import Foundation

class BuffManager {
    
    struct UnitBuff {
        var unit: Unit
        var buffs = [BuffObject]()
    }
    
    private var lastTappedUnitBattleIndex: Int?
    private weak var battleScene: BattleScene?
    var unitBuffs = [UnitBuff]()
    var bonusers = [Bonuser]()

    init(battleScene: BattleScene) {
        self.battleScene = battleScene
    }
    
    func initializeUnitBuffs() {
        guard let battleScene = battleScene else {return}
        for unit in battleScene.battleManager.units {
            let unitBuff: UnitBuff = UnitBuff(unit: unit)
            unitBuffs.append(unitBuff)
            let bonuser: Bonuser = Bonuser()
            bonusers.append(bonuser)
        }
    }
    
    func addBuffToUnit(buff: BuffObject, unit: Unit) {
        guard let battleScene = battleScene else {return}
        if buffExistInList(buff: buff, battleIndex: unit.battleIndex) || buff.stackable {
            if !buff.refreshable && !buff.stackable {
                return
            } else if buff.refreshable {
                refreshBuffInList(buff: buff, battleIndex: unit.battleIndex)
            } else {
                unitBuffs[unit.battleIndex].buffs.append(buff)
            }
        } else {
            unitBuffs[unit.battleIndex].buffs.append(buff)
        }
        
        showBuffIcon(battleIndex: unit.battleIndex)
        battleScene.updateCharacterNode(unit: unit)
    }
    
    private func buffExistInList(buff: BuffObject, battleIndex: Int) -> Bool {
        for item in unitBuffs[battleIndex].buffs {
            if item.sprite == buff.sprite {
                return true
            }
        }
        return false
    }
    
    private func refreshBuffInList(buff: BuffObject, battleIndex: Int) {
        var count = 0
        for item in unitBuffs[battleIndex].buffs {
            if item.sprite == buff.sprite {
                unitBuffs[battleIndex].buffs[count].refresh()
            }
            count += 1
        }
    }

    func processBuffs(requiredBuffType: BuffType, isAlly: Bool, battleIndex: Int, attacker: Unit?) {
        if battleIndex == -1 { // ALL, not ONE
            for i in stride(from: 0, through: unitBuffs.count-1, by: 1) {
                if unitBuffs[i].unit.isAlly != isAlly {continue}
                for j in stride(from: unitBuffs[i].buffs.count-1, through: 0, by: -1) {
                    activateBuff(requiredBuffType: requiredBuffType, i: i, j: j)
                }
            }
        } else {
            for j in stride(from: unitBuffs[battleIndex].buffs.count-1, through: 0, by: -1) {
                if unitBuffs[battleIndex].buffs[j].buffType == BuffType.BEFORE_DAMAGED ||
                    unitBuffs[battleIndex].buffs[j].buffType == BuffType.AFTER_DAMAGED {
                    activateDamagedBuff(attacker: attacker, i: battleIndex, j: j)
                } else {
                    activateBuff(requiredBuffType: requiredBuffType, i: battleIndex, j: j)
                }
            }
        }
    }
    
    private func activateBuff(requiredBuffType: BuffType, i: Int, j: Int) {
        if unitBuffs[i].buffs[j].buffType == requiredBuffType {
            if requiredBuffType == BuffType.BEFORE_TURN {
            }
            unitBuffs[i].buffs[j].activate(buffManager: self)
            unitBuffs[i].buffs[j].sustainabilitySubtractOne()
        }
        if unitBuffs[i].buffs[j].shouldBeRemoved() && !unitBuffs[i].buffs[j].needsRepealToBeRemoved() {
            unitBuffs[i].buffs.remove(at: j)
        }
    }
    
    private func activateDamagedBuff(attacker: Unit?, i: Int, j: Int) {
        guard let attacker = attacker else {return}
        unitBuffs[i].buffs[j].damagedActivate(attacker: attacker, buffManager: self)
        unitBuffs[i].buffs[j].sustainabilitySubtractOne()
        if unitBuffs[i].buffs[j].shouldBeRemoved() && !unitBuffs[i].buffs[j].needsRepealToBeRemoved() {
            unitBuffs[i].buffs.remove(at: j)
        }
    }
    
    func activateBeforeTurnBuffs(isAlly: Bool) {
        processBuffs(requiredBuffType: BuffType.BEFORE_TURN, isAlly: isAlly, battleIndex: -1, attacker: nil)
        showBuffIcon(battleIndex: lastTappedUnitBattleIndex ?? -1)
    }
    
    func activateAfterTurnBuffs(isAlly: Bool) {
        processBuffs(requiredBuffType: BuffType.AFTER_TURN, isAlly: isAlly, battleIndex: -1, attacker: nil)
        showBuffIcon(battleIndex: lastTappedUnitBattleIndex ?? -1)
    }
    
    func activateBeforeHealedBuffs(battleIndex: Int) {
        // isAlly is not important here
        processBuffs(requiredBuffType: BuffType.BEFORE_HEALED, isAlly: true, battleIndex: battleIndex, attacker: nil)
        showBuffIcon(battleIndex: lastTappedUnitBattleIndex ?? -1)
    }
    
    func activateAfterHealedBuffs(battleIndex: Int) {
        // isAlly is not important here
        processBuffs(requiredBuffType: BuffType.AFTER_HEALED, isAlly: true, battleIndex: battleIndex, attacker: nil)
        showBuffIcon(battleIndex: lastTappedUnitBattleIndex ?? -1)
    }
    
    func activateBeforeAttackBuffs(battleIndex: Int) {
        // isAlly is not important here
        processBuffs(requiredBuffType: BuffType.BEFORE_ATTACK, isAlly: true, battleIndex: battleIndex, attacker: nil)
        showBuffIcon(battleIndex: lastTappedUnitBattleIndex ?? -1)
    }
    
    func activateBeforeDamagedBuffs(battleIndex: Int, attacker: Unit) {
        // isAlly is not important here
        processBuffs(requiredBuffType: BuffType.BEFORE_DAMAGED, isAlly: true, battleIndex: battleIndex, attacker: attacker)
        showBuffIcon(battleIndex: lastTappedUnitBattleIndex ?? -1)
    }
    
    func activateAfterDamagedBuffs(battleIndex: Int, attacker: Unit) {
        // isAlly is not important here
        processBuffs(requiredBuffType: BuffType.AFTER_DAMAGED, isAlly: true, battleIndex: battleIndex, attacker: attacker)
        showBuffIcon(battleIndex: lastTappedUnitBattleIndex ?? -1)
    }
    
    func containsBuffMakeEnemyAttackFail(battleIndex: Int) -> Bool {
        var attackFail = false
        unitBuffs[battleIndex].buffs.forEach {
            if $0.makeEnemyAttackFail {
                attackFail = true
            }
        }
        return attackFail
    }
    
    func containsBuffMakeCarrierAttackFail(battleIndex: Int) -> Bool {
        var attackFail = false
        unitBuffs[battleIndex].buffs.forEach {
            if $0.makeCarrierAttackFail {
                attackFail = true
            }
        }
        return attackFail
    }
    
    func showBuffIcon(battleIndex: Int) { // add spritenodes to the camera
        if battleIndex < 0 {return}
        guard let battleScene = battleScene else {return}
        battleScene.buffIconLabel.removeAllChildren()
        lastTappedUnitBattleIndex = battleIndex
        var buffs: [BuffObject]
        buffs = unitBuffs[battleIndex].buffs
        let defX: Int = -630
        var i: Int = 0
        for buff in buffs {
            if i > 3 {break}
            if buff.shouldBeRemoved() && !buff.needsRepealToBeRemoved() {continue}
            let node = BuffIconNode(imageNamed: buff.sprite)
            node.anchorPoint = CGPoint(x: 0, y: 0.5)
            node.texture?.filteringMode = .linear
            node.size = CGSize(width: 60, height: 60)
            node.position = CGPoint(x: defX + i*60, y: -60)
            node.zPosition = zPositions.menuBar
            node.buildDescriptionPanel(buff: buff)
            battleScene.buffIconLabel.addChild(node)
            i += 1
        }
    }
    
    func updateCharacterNode(to unit: Unit) {
        guard let battleScene = battleScene else {return}
        battleScene.updateCharacterNode(unit: unit)
    }
    
    func updateHPBar(to unit: Unit) {
        guard let battleScene = battleScene else {return}
        battleScene.updateHPBar(to: unit)
    }
    
    func giveControlledUnitTurn(controlledUnitBattleIndex: Int) {
        guard let battleScene = battleScene else {return}
        battleScene.setControlledUnitBattleIndex(to: controlledUnitBattleIndex)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.playerGetNewTurnDelay, execute: {
            battleScene.setCurrentTurn(to: TurnSigns.PLAYER)
            battleScene.battleManager.units.forEach {$0.characterBase.isHidden = false}
        })
    }
    
    func getOriginalCarrierSkillSet(battleIndex: Int) -> [Skill] {
        return battleScene?.battleManager.originalSkillSetForUnits[battleIndex] ?? []
    }
}
