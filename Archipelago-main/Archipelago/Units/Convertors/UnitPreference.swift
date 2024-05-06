//
//  UnitPreference.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/28/23.
//

enum UnitPreference {
    case Ape
    case Snail
    case Dummy
    case Squirrel
    case Boar
    case Wolf
    case Deer
    case WoodNymph
    
    var preference: Int {
        get {
            switch self {
            case .Ape:
                return Preference.GENERAL_MELEE.rawValue
            case .Snail:
                return Preference.ROOK_MELEE.rawValue
            case .Dummy:
                return Preference.KNIGHT_RANGE.rawValue
            case .Squirrel:
                return Preference.GENERAL_MELEE.rawValue
            case .Boar:
                return Preference.ROOK_MELEE.rawValue
            case .Wolf:
                return Preference.ROOK_MELEE.rawValue
            case .Deer:
                return Preference.ROOK_MELEE.rawValue
            case .WoodNymph:
                return Preference.ROOK_MELEE.rawValue
            }
        }
    }
}
