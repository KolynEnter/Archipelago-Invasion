//
//  Irradiated.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/14/23.
//

// reduce target's 5% Current HP for two turns

struct Irradiated: BuffObject {
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
        sustainability = 2
        initSustainability = sustainability
        name = "Irradiated"
        description = ""
        sprite = "Irradiated"
        self.carryUnit = carryUnit
        self.applierUnit = applierUnit
        stackable = true
        refreshable = false
        buffType = BuffType.BEFORE_TURN
        makeEnemyAttackFail = false
        makeCarrierAttackFail = false
        numOfRepealRequired = 0
        onlyActivateWhenSustainabilityIsOne = false
    }
    
    func activate(buffManager: BuffManager) {
        HPManager().adjustByCurrentHealthPointRatio(targets: [carryUnit],
                                                    user: applierUnit,
                                                    hpRatio: 0.05,
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
