//
//  Water.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/18/23.
//


import SpriteKit

struct Water: TileObject {
    var tileName: String = "tile3"
    var x: CGFloat!
    var y: CGFloat!
    var isLiquid: Bool = true
    var isTall: Bool = false
    var isRandomTransport: Bool = false
    var canHideObject: Bool = false
    var isWalkable: Bool = false
    var gameTexture: TileTextures = TileTextures.Water
    var isEnterable: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

