//
//  LandTwo.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/18/23.
//

import SpriteKit

struct LandTwo: TileObject {
    var tileName: String = "tile2"
    var x: CGFloat!
    var y: CGFloat!
    var isLiquid: Bool = false
    var isTall: Bool = false
    var isRandomTransport: Bool = false
    var canHideObject: Bool = false
    var isWalkable: Bool = true
    var gameTexture: TileTextures = TileTextures.LandTwo
    var isEnterable: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
