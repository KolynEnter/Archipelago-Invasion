//
//  GameScene.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/6/23.
//

import SpriteKit
import GameplayKit

class GameScene: TouchScene {
    
    var mapCreator: GameMapCreator!
    var settingBackground: SKSpriteNode!
    var levelEnemyDataLoader = LevelEnemyDataLoader(fileName: "Map forest")
    var currentLevel: Int = 0 // starts at zero, plus one if used for display
    weak var viewController: GameViewController!
    
    private var rotator: GameSceneRotator!
    private var toucher: GameSceneToucher!
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.name = "GameScene"
        cameraNode = camera!
        if currentDeviceOrientation == DeviceOrientation.landscape {
            cameraNode.setScale(PincherMate.mapLandscapeMin.val)
        } else if currentDeviceOrientation == DeviceOrientation.portriat {
            cameraNode.setScale(PincherMate.mapPortraitMin.val)
        }
        
        if viewController.controller.getCurrentLevel() != -1 {
            self.currentLevel = viewController.controller.getCurrentLevel()
        }
        
        rotator = GameSceneRotator(gameScene: self)
        toucher = GameSceneToucher(gameScene: self)
        mapCreator = GameMapCreator(gameScene: self)
        
        if viewController.controller.isOnTown() {
            mapCreator.generateTownmap()
        } else {
            mapCreator.generateRandomMap(col: 16, row: 16, textureNames: [
                TileTextures.Grass.textureName,
                TileTextures.Water.textureName,
                TileTextures.Tree.textureName,
                TileTextures.Camp.textureName,
                TileTextures.Portal.textureName,
                TileTextures.Empty.textureName
            ])
        }
        
        guard let player = mapCreator.player else {return}
        addChild(player.getModel())
        cameraNode.position = player.position
        for enemy in mapCreator.enemies {
            addChild(enemy.getModel())
        }
        mapCreator.normalMap.name = "normal map"
        mapCreator.rotatedMap.name = "roated map"
        addChild(mapCreator.normalMap)
        addChild(mapCreator.rotatedMap)
        mapCreator.rotatedMap.isHidden = true
        createSettingBackground()
    }
    
    private func createSettingBackground() {
        settingBackground = SKSpriteNode(color: UIColor(white: 0, alpha: 0.7), size: CGSize(width: size.width, height: size.height))
        settingBackground.zPosition = zPositions.setting
        cameraNode.addChild(settingBackground)
        settingBackground.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if viewController.controller.isMenuOpened() {return}
        toucher.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if viewController.controller.isMenuOpened() {return}
        toucher.touchesEnded(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if viewController.controller.isMenuOpened() {return}
        //toucher.touchesMoved(touches, with: event) //
    }
    
    func rotated() {
        rotator.rotated()
    }
    
    deinit {
           print("\n THE SCENE \(type(of:self)) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
}
