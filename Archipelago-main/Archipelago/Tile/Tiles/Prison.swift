//
//  Prison.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/20/23.
//

import SpriteKit

struct Prison: TileObject {
    var tileName: String = "tile17"
    var x: CGFloat!
    var y: CGFloat!
    var isLiquid: Bool = false
    var isTall: Bool = false
    var isRandomTransport: Bool = false
    var canHideObject: Bool = false
    var isWalkable: Bool = true
    var gameTexture: TileTextures = TileTextures.Prison
    var isEnterable: Bool = true
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}