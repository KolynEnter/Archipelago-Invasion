//
//  FloatingButton.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/24/22.
//


import UIKit
import SpriteKit

class FloatingButton: SKSpriteNode {
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(yAxis: Int) {
        self.init(imageNamed: "SkillPanelButton")
        self.alpha = 0.8
        self.position = CGPoint(x: 0, y: yAxis)
        self.zPosition = zPositions.floatingButton
        self.setScale(0.8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
