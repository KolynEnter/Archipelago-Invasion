//
//  TileObject.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/26/22.
//

import SpriteKit

protocol TileObject {
    var tileName: String {get}
    var x: CGFloat! {get set}
    var y: CGFloat! {get set}
    var isLiquid: Bool  {get}
    var isTall: Bool  {get}
    var isRandomTransport: Bool  {get}
    var canHideObject: Bool  {get}
    var isWalkable: Bool  {get}
    var gameTexture: TileTextures {get}
    var isEnterable: Bool {get}
    
    init(x: CGFloat, y: CGFloat)
}
