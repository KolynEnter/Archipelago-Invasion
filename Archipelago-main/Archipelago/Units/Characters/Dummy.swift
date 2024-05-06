//
//  Dummy.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/29/22.
//

import UIKit
import SpriteKit
import SceneKit

class Dummy: Unit {
    
    init(isAlly: Bool) {
        super.init(imageNamed: UnitTextures.Dummy.textureName, preference: UnitPreference.Dummy.preference, isAlly: isAlly)
        hpMax = 100
        hpCurrent = hpMax
        atk = 25
        framePosition = CGPoint(x: -15, y: -110)
        skills.append(Strike())
        skills.append(Nightmare())
        skills.append(SwordDefenseSkill())
        skills.append(HeavyBlow())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

