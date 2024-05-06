//
//  Lighthouse.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/21/23.
//

import SpriteKit

struct Lighthouse: TileObject {
    var tileName: String = "tile17"
    var x: CGFloat!
    var y: CGFloat!
    var isLiquid: Bool = false
    var isTall: Bool = true
    var isRandomTransport: Bool = false
    var canHideObject: Bool = false
    var isWalkable: Bool = false
    var gameTexture: TileTextures = TileTextures.Lighthouse
    var isEnterable: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
