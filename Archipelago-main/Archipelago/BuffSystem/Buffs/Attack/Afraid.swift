//
//  Afraid.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/5/23.
//

// The next attack damage * 0.5

struct Afraid: BonusObject {
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
        name = "Afraid"
        description = ""
        sprite = "Afraid"
        self.carryUnit = carryUnit
        self.applierUnit = applierUnit
        stackable = false
        refreshable = false
        buffType = BuffType.BEFORE_ATTACK
        makeEnemyAttackFail = false
        makeCarrierAttackFail = false
        numOfRepealRequired = 0
        onlyActivateWhenSustainabilityIsOne = false
    }
    
    func activate(buffManager: BuffManager) {
        buffManager.bonusers[carryUnit.battleIndex].addBonus(stat: .ATTACK, mag: Magnification(operation: .MULTIPLY, modifingRate: 0.5))
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
