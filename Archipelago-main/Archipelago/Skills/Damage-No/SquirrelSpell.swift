//
//  SquirrelSpell.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/16/23.
//

/*
 
 Turn the specified target into a squirrel for two turns
 effect is cleared after the second turn of target ends
 When applied, clear all buffs the target has
 during effect, target has 'Squirrelized' buff
 during effect, replace target's skill set to
 during effect, replace target's sprite sheet to Squirrel
 [Polish, Claw]
 
 */

import MetalKit
import SpriteKit

struct SquirrelSpell: Skill {
    var name: String = "Squirrel Spell"
    var description: String = ""
    var skillType: SkillType = .SOLO
    var range: SpecificationRange = .LOCAL
    var isSelfBuff: Bool = false
    var originalCooldown: Int = 8
    var currentCooldown: Int = 0
    
    func activate(user: Unit, targets: [Unit], buffManager: BuffManager) {
        buffManager.unitBuffs[targets[0].battleIndex].buffs = []
        buffManager.addBuffToUnit(buff: Squirrelized(carryUnit: targets[0], applierUnit: user), unit: targets[0])
        if user.battleIndex == targets[0].battleIndex {
            user.isJustBeenMorphedBySelf = true
        }
        targets[0].skills = [Polish(), Claw()]
        TextureManager.sharedInstance.addTexture(withName: stringToUnitTextureName(imageName: "Squirrel"))
        if let squirrelTexture = TextureManager.sharedInstance.getTexture(withName: stringToUnitTextureName(imageName: "Squirrel")) {
            targets[0].run(SKAction.setTexture(squirrelTexture))
            
            if let device = MTLCreateSystemDefaultDevice() {
                let manager = MetalTextureManagement(textureLoader: MTKTextureLoader(device: device))
                if let cg = targets[0].texture?.cgImage() {
                    if let tex = try? manager.texture(from: cg, usage: .shaderRead) {
                        if let converted = try? manager.cgImage(from: tex) {
                            let newTexture = SKTexture(cgImage: converted)
                            targets[0].texture = newTexture
                        }
                    }
                }
            }
            TextureManager.sharedInstance.removeAllTextures()
        }
    }
}
