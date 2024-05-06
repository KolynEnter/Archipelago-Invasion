//
//  Bonuser.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/23/22.
//

// Given an input, the input will go through a series of modifications to become an output

class Bonuser {
    private var attackMap: [Magnification: Int] = [:]
    private var healMap: [Magnification: Int] = [:]
    private var defenseMap: [Magnification: Int] = [:]
    
    func addBonus(stat: Stat, mag: Magnification) {
        switch stat {
        case .ATTACK:
            addAttackBonus(mag: mag)
            return
        case .HEAL:
            addHealBonus(mag: mag)
            return
        case .DEFENSE:
            addDefenseBonus(mag: mag)
            return
        }
    }
     
    // if a mag exists, increment it, otherwise add it
    private func addAttackBonus(mag: Magnification) {
        for (key, value) in attackMap {
            if key == mag {
                attackMap[key] = value + 1
                return
            }
        }
        attackMap[mag] = 1
    }
    
    private func addHealBonus(mag: Magnification) {
        for (key, value) in healMap {
            if key == mag {
                healMap[key] = value + 1
                return
            }
        }
        healMap[mag] = 1
    }
    
    private func addDefenseBonus(mag: Magnification) {
        for (key, value) in defenseMap {
            if key == mag {
                defenseMap[key] = value + 1
                return
            }
        }
        defenseMap[mag] = 1
    }
    
    func applyBonus(stat: Stat, source: Float) -> Float {
        switch stat {
        case .ATTACK:
            return applyAttackBonus(source: source)
        case .HEAL:
            return applyHealBonus(source: source)
        case .DEFENSE:
            return applyDefenseBonus(source: source)
        }
    }
    
    private func applyAttackBonus(source: Float) -> Float {
        var result: Float = source
        for (key, value) in attackMap {
            switch key.operation {
            case .ADD:
                result += key.modifingRate
                break;
            case .SUBTRACT:
                result -= key.modifingRate
                break;
            case .MULTIPLY:
                result *= key.modifingRate
                break;
            case .DIVIDE:
                result /= key.modifingRate
                break;
            }
            if (value - 1) == 0 {
                attackMap.removeValue(forKey: key)
            } else {
                attackMap[key] = value - 1
            }
        }
        return result
    }
    
    private func applyHealBonus(source: Float) -> Float {
        var result: Float = source
        for (key, value) in healMap {
            switch key.operation {
            case .ADD:
                result += key.modifingRate
                break;
            case .SUBTRACT:
                result -= key.modifingRate
                break;
            case .MULTIPLY:
                result *= key.modifingRate
                break;
            case .DIVIDE:
                result /= key.modifingRate
                break;
            }
            if (value - 1) == 0 {
                healMap.removeValue(forKey: key)
            } else {
                healMap[key] = value - 1
            }
        }
        return result
    }
    
    private func applyDefenseBonus(source: Float) -> Float {
        var result: Float = source
        for (key, value) in defenseMap {
            switch key.operation {
            case .ADD:
                result += key.modifingRate
                break;
            case .SUBTRACT:
                result -= key.modifingRate
                break;
            case .MULTIPLY:
                result *= key.modifingRate
                break;
            case .DIVIDE:
                result /= key.modifingRate
                break;
            }
            if (value - 1) == 0 {
                defenseMap.removeValue(forKey: key)
            } else {
                defenseMap[key] = value - 1
            }
        }
        return result
    }
}
