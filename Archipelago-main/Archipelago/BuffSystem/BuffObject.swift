//
//  BuffObject.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/23/22.

protocol BuffObject {
    var sustainability: Int {get set}
    var initSustainability: Int {get}
    var name: String {get}
    var description: String {get}
    var sprite: String {get}
    var carryUnit: Unit {get set}
    var applierUnit: Unit {get set}
    var stackable: Bool {get}
    var refreshable: Bool {get}
    var buffType: BuffType {get}
    var makeEnemyAttackFail: Bool {get}
    var makeCarrierAttackFail: Bool {get}
    var numOfRepealRequired: Int {get set}
    var onlyActivateWhenSustainabilityIsOne: Bool {get set}
    
    init(carryUnit: Unit, applierUnit: Unit)
    func activate(buffManager: BuffManager)
    func damagedActivate(attacker: Unit, buffManager: BuffManager)
    mutating func sustainabilitySubtractOne()
    mutating func sustainabilityToZero()
    mutating func refresh()
    mutating func numOfRepealRequiredSubtractOne()
    mutating func numOfRepealRequiredToZero()
}

extension BuffObject {
    func shouldBeRemoved() -> Bool {
        return sustainability <= 0
    }
    
    func descriptionName() -> String {
        return sprite
    }
    
    func descriptionStack() -> String {
        return "Stack: " + String(sustainability)
    }

    func needsRepealToBeRemoved() -> Bool {
        return numOfRepealRequired > 0
    }
}
