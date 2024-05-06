//
//  Boar.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/3/23.
//

import UIKit
import SpriteKit
import SceneKit

class Boar: Unit {
    
    init(isAlly: Bool) {
        super.init(imageNamed: UnitTextures.Boar.textureName, preference: UnitPreference.Boar.preference, isAlly: isAlly)
        hpMax = 100
        hpCurrent = hpMax
        atk = 5
        framePosition = CGPoint(x: 70, y: -10)
        skills.append(Strike())
        skills.append(SwordDefenseSkill())
        skills.append(IceBeam())
        skills.append(SleepGas())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
