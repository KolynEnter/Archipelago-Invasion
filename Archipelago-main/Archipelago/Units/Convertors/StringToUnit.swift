//
//  StringToUnit.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/1/23.
//

func stringToUnit(imageName: String) -> Unit {
    switch imageName {
    case "Ape":
        return Ape(isAlly: false)
    case "Snail":
        return Snail(isAlly: false)
    case "Dummy":
        return Dummy(isAlly: false)
    case "Squirrel":
        return Squirrel(isAlly: false)
    case "Boar":
        return Boar(isAlly: false)
    case "Wolf":
        return Wolf(isAlly: false)
    case "Deer":
        return Deer(isAlly: false)
    case "WoodNymph":
        return WoodNymph(isAlly: false)
    default:
        return Dummy(isAlly: false)
    }
}
