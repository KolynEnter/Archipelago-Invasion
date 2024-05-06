//
//  GameTextures.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/24/23.
//

import SpriteKit

enum TileTextures {
    case Empty
    case LandOne
    case LandTwo
    case Water
    case Camp
    case Portal
    case Grass
    case Tree
    case Mushroom
    case Mountain
    case TownSign
    case TownShop
    case TownInn
    case Lighthouse
    case AlchemistHouse
    case Arena
    case Guild
    case Prison
    case Fence
    
    var textureName: String {
        get {
            switch self {
            case .Empty:
                return "Empty Tile.astc"
            case .LandOne:
                return "LandOne Tile.astc"
            case .LandTwo:
                return "LandTwo Tile.astc"
            case .Water:
                return "Water Tile.astc"
            case .Camp:
                return "Camp Tile.astc"
            case .Portal:
                return "Portal Tile.astc"
            case .Grass:
                return "Grass Tile.astc"
            case .Tree:
                return "Tree Tile.astc"
            case .Mushroom:
                return "Mushroom Tile.astc"
            case .Mountain:
                return "Mountain Tile.astc"
            case .TownSign:
                return "Sign.astc"
            case .TownShop:
                return "Shop.astc"
            case .TownInn:
                return "Inn.astc"
            case .Lighthouse:
                return "tile17"
            case .AlchemistHouse:
                return "AlchemistHouse.astc"
            case .Arena:
                return "Arena.astc"
            case .Guild:
                return "Guild.astc"
            case .Prison:
                return "tile17"
            case .Fence:
                return "Fence.astc"
            }
        }
    }
}
