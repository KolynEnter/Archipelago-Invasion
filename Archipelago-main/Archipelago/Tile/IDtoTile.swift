//
//  IDtoTile.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/19/23.
//

import SpriteKit

func idToTile(id: TileID, x: CGFloat, y: CGFloat) -> TileObject{
    switch(id) {
    case .LandOne:
        return LandOne(x: x, y: y)
    case .LandTwo:
        return LandTwo(x: x, y: y)
    case .Water:
        return Water(x: x, y: y)
    case .Camp:
        return Camp(x: x, y: y)
    case .Portal:
        return Portal(x: x, y: y)
    case .Grass:
        return Grass(x: x, y: y)
    case .Tree:
        return Tree(x: x, y: y)
    case .Mushroom:
        return Mushroom(x: x, y: y)
    case .Mountain:
        return Mountain(x: x, y: y)
    case .TownSign:
        return TownSign(x: x, y: y)
    case .TownShop:
        return TownShop(x: x, y: y)
    case .TownInn:
        return TownInn(x: x, y: y)
    case .Lighthouse:
        return Lighthouse(x: x, y: y)
    case .AlchemistHouse:
        return AlchemistHouse(x: x, y: y)
    case .Arena:
        return Arena(x: x, y: y)
    case .Guild:
        return Guild(x: x, y: y)
    case .Prison:
        return Prison(x: x, y: y)
    case .Fence:
        return Fence(x: x, y: y)
    }
}
