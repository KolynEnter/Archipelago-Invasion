//
//  StringToUnitTexture.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/1/23.
//

func stringToUnitTextureName(imageName: String) -> String {
    switch imageName {
    case "Ape":
        return UnitTextures.Ape.textureName
    case "Snail":
        return UnitTextures.Snail.textureName
    case "Dummy":
        return UnitTextures.Dummy.textureName
    case "Squirrel":
        return UnitTextures.Squirrel.textureName
    case "Boar":
        return UnitTextures.Boar.textureName
    case "Wolf":
        return UnitTextures.Wolf.textureName
    case "Deer":
        return UnitTextures.Deer.textureName
    case "WoodNymph":
        return UnitTextures.WoodNymph.textureName
    default:
        return UnitTextures.Dummy.textureName
    }
}
