//
//  StringToUnitID.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/2/23.
//

func stringToUnitID(imageName: String) -> Int? {
    switch imageName {
    case "Ape":
        return UnitID.Ape.index
    case "Snail":
        return UnitID.Snail.index
    case "Dummy":
        return UnitID.Dummy.index
    case "Squirrel":
        return UnitID.Squirrel.index
    case "Boar":
        return UnitID.Boar.index
    case "Wolf":
        return UnitID.Wolf.index
    case "Deer":
        return UnitID.Deer.index
    case "WoodNymph":
        return UnitID.WoodNymph.index
    default:
        return UnitID.Dummy.index
    }
}
