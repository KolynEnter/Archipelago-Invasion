//
//  Sleeping.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/6/23.
//

// The carrier will sleep until the effect is repealed or the carrier is attacked

struct Sleeping: BuffObject {
    var sustainability: Int
    var initSustainability: Int
    var name: String
    var description: String
    var sprite: String
    var carryUnit: Unit
    var applierUnit: Unit
    var stackable: Bool
    var refreshable: Bool
    var buffType: BuffType
    var makeEnemyAttackFail: Bool
    var makeCarrierAttackFail: Bool
    var numOfRepealRequired: Int
    var onlyActivateWhenSustainabilityIsOne: Bool
    
    init(carryUnit: Unit, applierUnit: Unit) {
        sustainability = 1
        initSustainability = sustainability
        name = "Sleeping"
        description = ""
        sprite = "Sleeping"
        self.carryUnit = carryUnit
        self.applierUnit = applierUnit
        stackable = false
        refreshable = false
        buffType = BuffType.AFTER_DAMAGED
        makeEnemyAttackFail = false
        makeCarrierAttackFail = false
        numOfRepealRequired = sustainability
        self.carryUnit.cannotMove = true
        onlyActivateWhenSustainabilityIsOne = false
    }
    
    func activate(buffManager: BuffManager) {
        
    }
    
    func damagedActivate(attacker: Unit, buffManager: BuffManager) {
        // repeal this buff
        // 1. Find this buff in carrier's buff list
        var otherRepealRequired = false
        var count = 0
        for buff in buffManager.unitBuffs[carryUnit.battleIndex].buffs {
            if buff.sprite == "Sleeping" {
                // 2. Repeal
                buffManager.unitBuffs[carryUnit.battleIndex].buffs[count].numOfRepealRequiredToZero()
                buffManager.unitBuffs[carryUnit.battleIndex].buffs[count].sustainabilityToZero()
            } else {
                if buff.needsRepealToBeRemoved() {
                    otherRepealRequired = true
                }
            }
            count += 1
        }
        if !otherRepealRequired {
            carryUnit.cannotMove = false
        }
        buffManager.updateCharacterNode(to: carryUnit)
    }

    mutating func sustainabilitySubtractOne() {
        if !needsRepealToBeRemoved()  && sustainability > 0 {
            sustainability -= 1
        }
    }
    
    mutating func sustainabilityToZero() {
        sustainability = 0
    }
    
    mutating func refresh() {
        sustainability = initSustainability
    }
    
    mutating func numOfRepealRequiredSubtractOne() {
        numOfRepealRequired -= 1
    }
    
    mutating func numOfRepealRequiredToZero() {
        numOfRepealRequired = 0
    }
}
