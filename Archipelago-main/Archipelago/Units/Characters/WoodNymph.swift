//
//  WoodenNymph.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/6/23.
//

import UIKit
import SpriteKit
import SceneKit

class WoodNymph: Unit {
    
    init(isAlly: Bool) {
        super.init(imageNamed: UnitTextures.WoodNymph.textureName, preference: UnitPreference.WoodNymph.preference, isAlly: isAlly)
        hpMax = 1000
        hpCurrent = hpMax
        atk = 1000
        framePosition = CGPoint(x: 0, y: -100)
        skills.append(SoulStrike())
        skills.append(Nightmare())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
