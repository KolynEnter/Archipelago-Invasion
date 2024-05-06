//
//  Dead.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/4/23.
//

struct Dead: BuffObject {
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
        sustainability = 999
        initSustainability = sustainability
        name = "Dead"
        description = ""
        sprite = "Dead"
        self.carryUnit = carryUnit
        self.applierUnit = applierUnit
        stackable = false
        refreshable = false
        buffType = BuffType.SPECIAL
        makeEnemyAttackFail = false
        makeCarrierAttackFail = false
        numOfRepealRequired = sustainability
        carryUnit.isAlive = false
        carryUnit.color = .black
        carryUnit.colorBlendFactor = 0.7
        onlyActivateWhenSustainabilityIsOne = false
    }
    
    func activate(buffManager: BuffManager) {
        
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
