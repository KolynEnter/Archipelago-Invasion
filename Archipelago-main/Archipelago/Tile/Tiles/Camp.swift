//
//  Camp.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/18/23.
//

import SpriteKit

struct Camp: TileObject {
    var tileName: String = "tile4"
    var x: CGFloat!
    var y: CGFloat!
    var isLiquid: Bool = false
    var isTall: Bool = false
    var isRandomTransport: Bool = false
    var canHideObject: Bool = false
    var isWalkable: Bool = true
    var gameTexture: TileTextures = TileTextures.Camp
    var isEnterable: Bool = true
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
