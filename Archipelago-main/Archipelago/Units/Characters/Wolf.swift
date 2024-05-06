//
//  Wolf.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/6/23.
//

import UIKit
import SpriteKit
import SceneKit

class Wolf: Unit {
    
    init(isAlly: Bool) {
        super.init(imageNamed: UnitTextures.Wolf.textureName, preference: UnitPreference.Wolf.preference, isAlly: isAlly)
        hpMax = 100
        hpCurrent = hpMax
        atk = 5
        framePosition = CGPoint(x: 90, y: 10)
        skills.append(Strike())
        skills.append(SwordDefenseSkill())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
