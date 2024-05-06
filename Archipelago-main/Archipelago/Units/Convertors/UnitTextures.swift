//
//  UnitTextures.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/28/23.
//

import SpriteKit

enum UnitTextures {
    case Ape
    case Snail
    case Dummy
    case Squirrel
    case Boar
    case Wolf
    case Deer
    case WoodNymph
    
    var textureName: String {
        get {
            switch self {
            case .Ape:
                return "Ape"
            case .Snail:
                return "Snail"
            case .Dummy:
                return "Dummy"
            case .Squirrel:
                return "Squirrel"
            case .Boar:
                return "Boar"
            case .Wolf:
                return "Wolf"
            case .Deer:
                return "Deer"
            case .WoodNymph:
                return "WoodNymph"
            }
        }
    }
}
