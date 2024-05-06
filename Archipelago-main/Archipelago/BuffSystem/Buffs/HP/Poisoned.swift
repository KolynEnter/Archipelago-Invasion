//
//  Poisoned.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/23/22.
//

// Reduce target's 10% Current HP for one turn

struct Poisoned: BuffObject {
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
        name = "Poisoned"
        description = ""
        sprite = "Poisoned"
        self.carryUnit = carryUnit
        self.applierUnit = applierUnit
        stackable = false
        refreshable = false
        buffType = BuffType.AFTER_TURN
        makeEnemyAttackFail = false
        makeCarrierAttackFail = false
        numOfRepealRequired = 0
        onlyActivateWhenSustainabilityIsOne = false
    }
    
    func activate(buffManager: BuffManager) {
        HPManager().adjustByCurrentHealthPointRatio(targets: [carryUnit],
                                                    user: applierUnit,
                                                    hpRatio: 0.1,
                                                    buffManager: buffManager,
                                                    adjustment: {return $0 - $1})
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
