//
//  Mountain.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/18/23.
//

import SpriteKit

struct Mountain: TileObject {
    var tileName: String = "tile9"
    var x: CGFloat!
    var y: CGFloat!
    var isLiquid: Bool = false
    var isTall: Bool = true
    var isRandomTransport: Bool = false
    var canHideObject: Bool = false
    var isWalkable: Bool = false
    var gameTexture: TileTextures = TileTextures.Mountain
    var isEnterable: Bool = false
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
