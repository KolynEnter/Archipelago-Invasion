//
//  Squirrelized.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/16/23.
//

import SpriteKit
import MetalKit

struct Squirrelized: BuffObject {
    var sustainability: Int
    var initSustainability: Int
    var name: String
    var description: String
    var sprite: String
    var carryUnit: Unit
    var applierUnit: Unit
    var stackable: Bool
    var refreshable: Bool
    var buffType: BuffType
    var makeEnemyAttackFail: Bool
    var makeCarrierAttackFail: Bool
    var numOfRepealRequired: Int
    var onlyActivateWhenSustainabilityIsOne: Bool
    
    init(carryUnit: Unit, applierUnit: Unit) {
        sustainability = 5
        initSustainability = sustainability
        name = "Squirrelized"
        description = ""
        sprite = "Squirrelized"
        self.carryUnit = carryUnit
        self.applierUnit = applierUnit
        stackable = false
        refreshable = false
        buffType = BuffType.AFTER_TURN
        makeEnemyAttackFail = false
        makeCarrierAttackFail = false
        numOfRepealRequired = 0
        self.carryUnit.cannotMove = false
        onlyActivateWhenSustainabilityIsOne = true
    }
    
    func activate(buffManager: BuffManager) {
        if onlyActivateWhenSustainabilityIsOne && sustainability == 1 {
            // recover the skill set back to carrier's original
            carryUnit.skills = buffManager.getOriginalCarrierSkillSet(battleIndex: carryUnit.battleIndex)
            // recover the sprite sheet back to carrier's original
            TextureManager.sharedInstance.addTexture(withName: carryUnit.getImageName())
            
            if let originalTexture = TextureManager.sharedInstance.getTexture(withName: carryUnit.getImageName()) {
                carryUnit.run(SKAction.setTexture(originalTexture))
                
                if let device = MTLCreateSystemDefaultDevice() {
                    let manager = MetalTextureManagement(textureLoader: MTKTextureLoader(device: device))
                    if let cg = carryUnit.texture?.cgImage() {
                        if let tex = try? manager.texture(from: cg, usage: .shaderRead) {
                            if let converted = try? manager.cgImage(from: tex) {
                                let newTexture = SKTexture(cgImage: converted)
                                carryUnit.texture = newTexture
                            }
                        }
                    }
                }
                TextureManager.sharedInstance.removeAllTextures()
            }
        }
        if applierUnit.battleIndex == carryUnit.battleIndex {
            carryUnit.skills[carryUnit.skills.firstIndex(where: {$0.name == "Squirrel Spell"}) ?? 0].currentCooldown =
            carryUnit.skills[carryUnit.skills.firstIndex(where: {$0.name == "Squirrel Spell"}) ?? 0].originalCooldown
        }
    }
    
    func damagedActivate(attacker: Unit, buffManager: BuffManager) {
        
    }
    
    mutating func sustainabilitySubtractOne() {
        if !needsRepealToBeRemoved()  && sustainability > 0 {
            sustainability -= 1
        }
    }
    
    mutating func sustainabilityToZero() {
        sustainability = 0
    }
    
    mutating func refresh() {
        sustainability = initSustainability
    }
    
    mutating func numOfRepealRequiredSubtractOne() {
        numOfRepealRequired -= 1
    }
    
    mutating func numOfRepealRequiredToZero() {
        numOfRepealRequired = 0
    }
}
