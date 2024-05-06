//
//  Snail.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/29/22.
//

import UIKit
import SpriteKit
import SceneKit

class Snail: Unit {
    
    init(isAlly: Bool) {
        super.init(imageNamed: UnitTextures.Snail.textureName, preference: UnitPreference.Snail.preference, isAlly: isAlly)
        hpMax = 100
        hpCurrent = hpMax
        atk = 25
        framePosition = CGPoint(x: 70, y: -30)
        skills.append(Strike())
        skills.append(Sting())
        skills.append(Claw())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

