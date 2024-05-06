//
//  StringToUnitPreference.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/1/23.
//

func stringToUnitPreference(imageName: String) -> Int {
    switch imageName {
    case "Ape":
        return UnitPreference.Ape.preference
    case "Snail":
        return UnitPreference.Snail.preference
    case "Dummy":
        return UnitPreference.Dummy.preference
    case "Squirrel":
        return UnitPreference.Squirrel.preference
    case "Boar":
        return UnitPreference.Boar.preference
    case "Wolf":
        return UnitPreference.Wolf.preference
    case "Deer":
        return UnitPreference.Deer.preference
    case "WoodNymph":
        return UnitPreference.WoodNymph.preference
    default:
        return UnitPreference.Dummy.preference
    }
}
