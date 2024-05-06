//
//  Squirrel.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/3/23.
//

import UIKit
import SpriteKit
import SceneKit

class Squirrel: Unit {
    
    init(isAlly: Bool) {
        super.init(imageNamed: UnitTextures.Squirrel.textureName, preference: UnitPreference.Squirrel.preference, isAlly: isAlly)
        hpMax = 100
        hpCurrent = hpMax
        atk = 5
        framePosition = CGPoint(x: 70, y: 0)
        skills.append(Strike())
        skills.append(Sting())
        skills.append(Claw())
        skills.append(Polish())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
