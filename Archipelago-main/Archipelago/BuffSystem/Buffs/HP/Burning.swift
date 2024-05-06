//
//  Burning.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/25/22.
//

// reduce target's CurrentHP with user's atk * 0.3

struct Burning: BuffObject {
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
        name = "Burning"
        description = ""
        sprite = "Burning"
        self.carryUnit = carryUnit
        self.applierUnit = applierUnit
        stackable = false
        refreshable = false
        buffType = BuffType.BEFORE_TURN
        makeEnemyAttackFail = false
        makeCarrierAttackFail = false
        numOfRepealRequired = 0
        onlyActivateWhenSustainabilityIsOne = false
    }
    
    func activate(buffManager: BuffManager) {
        HPManager().adjustByUserAttackRatio(targets: [carryUnit], user: applierUnit, attackRatio: 0.3, buffManager: buffManager)
    }
    
    func damagedActivate(attacker: Unit, buffManager: BuffManager) {
        
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
