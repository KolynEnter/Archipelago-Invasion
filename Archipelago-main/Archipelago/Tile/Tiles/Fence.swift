//
//  Fence.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/20/23.
//

import SpriteKit

struct Fence: TileObject {
    var tileName: String = "tile18"
    var x: CGFloat!
    var y: CGFloat!
    var isLiquid: Bool = false
    var isTall: Bool = true
    var isRandomTransport: Bool = false
    var canHideObject: Bool = false
    var isWalkable: Bool = false
    var gameTexture: TileTextures = TileTextures.Fence
    var isEnterable: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
