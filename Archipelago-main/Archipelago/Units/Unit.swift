//
//  Unit.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/23/22.
//

import UIKit
import SpriteKit
import SceneKit
import MetalKit

public class Unit: SKSpriteNode {
    
    var battleIndex: Int = 0
    var isAlive = true
    var isAlly = true {
        didSet {
            if isAlly {
                characterBase.texture = SKTexture(imageNamed: "SelectionMarkerAlly")
            } else {
                characterBase.texture = SKTexture(imageNamed: "SelectionMarkerEnemy")
            }
        }
    }
    var cannotMove = false
    var fontColor: UIColor {
        get {
            if isAlly {
                return COLOR_ALLY
            } else {
                return COLOR_ENEMY
            }
        }
    }
    var floatingPanelIsShown = false
    private var image_name: String!
    var preference: Int = 0
    var framePosition: CGPoint = CGPoint(x: 0, y: 0)
    let characterBase = SKSpriteNode(imageNamed: "SelectionMarker")
    var skills: [Skill] = []
    var originalSkills: [Skill] = []
    
    var hpMax: Float = 0
    var hpCurrent: Float = 0
    var atk: Float = 0
    
    var uniqueID: String = UUID().uuidString // for identification
    var isJustBeenMorphedBySelf: Bool = false
    
    init(imageNamed: String, preference: Int, isAlly: Bool) {
        self.image_name = imageNamed
        let texture = SKTexture(imageNamed: imageNamed)
        self.preference = preference
        super.init(texture: texture, color: .clear, size: texture.size())
        self.texture?.filteringMode = .linear
        self.zPosition = zPositions.unit
        self.isAlly = isAlly
        
        if isAlly {
            characterBase.texture = SKTexture(imageNamed: "SelectionMarkerAlly")
        } else {
            characterBase.texture = SKTexture(imageNamed: "SelectionMarkerEnemy")
        }
        
        if let device = MTLCreateSystemDefaultDevice() {
            let manager = MetalTextureManagement(textureLoader: MTKTextureLoader(device: device))
            if let cg = self.texture?.cgImage() {
                if let tex = try? manager.texture(from: cg, usage: .shaderRead) {
                    if let converted = try? manager.cgImage(from: tex) {
                        let newTexture = SKTexture(cgImage: converted)
                        self.texture = newTexture
                    }
                }
            }
        }
        
        characterBase.position = CGPoint(x: 0, y: 0)
        characterBase.texture?.filteringMode = .nearest
        characterBase.zPosition = zPositions.unit-1
        characterBase.scale(to: CGSize(width: characterBase.size.width*0.9, height: characterBase.size.height*0.9))
        characterBase.alpha = 0.5
        self.addChild(characterBase)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func move(to target: SKNode) {
        self.characterBase.isHidden = false
        run(SKAction.move(to: target.position, duration: TimeController.regularUnitMoveDelay))
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.regularUnitMoveDelay, execute: {
            self.position = target.position
        })
    }
    
    func move(to position: CGPoint) {
        self.characterBase.isHidden = false
        run(SKAction.move(to: position, duration: TimeController.regularUnitMoveDelay))
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.regularUnitMoveDelay, execute: {
            self.position = position
        })
    }
    
    func attack(target: Unit, cameraXScale: CGFloat) -> SKSpriteNode { // In file "Attack Button"
        if self.cannotMove {
            let repealPanel = useRepealSet(user: self, target: target, cameraXScale: cameraXScale)
            self.parent?.addChild(repealPanel)
            return repealPanel
        }
        if panelShownAlready(userSkills: skills, user: self, target: target) {return SKSpriteNode()}
        var panel = SKSpriteNode()
        switch skills.count {
        case 1:
            panel = skillRows(numberOfSkillRow: 1, userSkills: skills, user: self, target: target, cameraXScale: cameraXScale)
            break
        case 2:
            panel = skillRows(numberOfSkillRow: 2, userSkills: skills, user: self, target: target, cameraXScale: cameraXScale)
            break
        case 3:
            panel = skillRows(numberOfSkillRow: 3, userSkills: skills, user: self, target: target, cameraXScale: cameraXScale)
            break
        case 4:
            panel = skillRows(numberOfSkillRow: 4, userSkills: skills, user: self, target: target, cameraXScale: cameraXScale)
            break
        default:
            break
        }
        
        self.parent?.addChild(panel)
        return panel
    }
    
    func getImageName() -> String{
        return image_name
    }
    
    func clearCDForAllSkills() {
        for i in 0 ..< skills.count {
            skills[i].currentCooldown = 0
        }
    }
}
