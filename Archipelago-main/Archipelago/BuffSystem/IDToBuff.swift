//
//  IDToBuff.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/14/23.
//

func idToBuff(id: BuffID, carryUnit: Unit, applierUnit: Unit) -> BuffObject {
    switch(id) {
    case .Dead:
        return Dead(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Frozen:
        return Frozen(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Stunned:
        return Stunned(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Sleeping:
        return Sleeping(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Polishing:
        return Polishing(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Afraid:
        return Afraid(carryUnit: carryUnit, applierUnit: applierUnit)
    case .AttackDown:
        return AttackDown(carryUnit: carryUnit, applierUnit: applierUnit)
    case .AttackUp:
        return AttackUp(carryUnit: carryUnit, applierUnit: applierUnit)
    case .SwordDefense:
        return SwordDefense(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Blind:
        return Blind(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Poisoned:
        return Poisoned(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Burning:
        return Burning(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Bleeding:
        return Bleeding(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Irradiated:
        return Irradiated(carryUnit: carryUnit, applierUnit: applierUnit)
    case .MindControlled:
        return MindControlled(carryUnit: carryUnit, applierUnit: applierUnit)
    case .Squirrelized:
        return Squirrelized(carryUnit: carryUnit, applierUnit: applierUnit)
    }
}
