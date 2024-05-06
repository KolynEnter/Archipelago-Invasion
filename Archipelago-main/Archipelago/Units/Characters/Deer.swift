//
//  Deer.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/6/23.
//

import UIKit
import SpriteKit
import SceneKit

class Deer: Unit {
    
    init(isAlly: Bool) {
        super.init(imageNamed: UnitTextures.Deer.textureName, preference: UnitPreference.Deer.preference, isAlly: isAlly)
        hpMax = 100
        hpCurrent = hpMax
        atk = 5
        framePosition = CGPoint(x: 90, y: -30)
        skills.append(SwordDefenseSkill())
        skills.append(SleepGas())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
