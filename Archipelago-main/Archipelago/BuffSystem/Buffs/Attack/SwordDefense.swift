//
//  SwordDefense.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//

/*
Before receive damage, ignore this damage and return
carrier's raw attack - attacker's raw attack damage to
the attacker
 */

struct SwordDefense: BuffObject {
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
        name = "Sword Defense"
        description = ""
        sprite = "Sword Defense"
        self.carryUnit = carryUnit
        self.applierUnit = applierUnit
        stackable = false
        refreshable = false
        buffType = BuffType.BEFORE_DAMAGED
        makeEnemyAttackFail = true
        makeCarrierAttackFail = false
        numOfRepealRequired = 0
        onlyActivateWhenSustainabilityIsOne = false
    }
    
    func activate(buffManager: BuffManager) {
        
    }
    
    func damagedActivate(attacker: Unit, buffManager: BuffManager) {
        var returnDamage: Float = carryUnit.atk - attacker.atk
        if returnDamage < 0 {returnDamage = 0}
        HPManager().adjustByFixedDamage(targets: [attacker],
                                        user: carryUnit,
                                        amount: returnDamage,
                                        buffManager: buffManager,
                                        adjustment: {return $0 - $1})
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
