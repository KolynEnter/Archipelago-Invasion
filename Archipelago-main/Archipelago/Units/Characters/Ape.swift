//
//  Ape.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/29/22.
//

import UIKit
import SpriteKit
import SceneKit

class Ape: Unit {
    
    init(isAlly: Bool) {
        super.init(imageNamed: UnitTextures.Ape.textureName, preference: UnitPreference.Ape.preference, isAlly: isAlly)
        hpMax = 100
        hpCurrent = hpMax
        atk = 5
        framePosition = CGPoint(x: 0, y: -100)
        skills.append(Strike())
        skills.append(Sting())
        skills.append(Claw())
        skills.append(MagicLight())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
