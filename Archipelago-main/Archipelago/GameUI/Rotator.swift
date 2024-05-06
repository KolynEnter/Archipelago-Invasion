//
//  Rotator.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/10/23.
//

import SpriteKit

class GameSceneRotator {
    
    weak var gameScene: GameScene?
    var lastFrameX: CGFloat = 0 // a hacky way to fix a serious rotation bug
    var startedAs: Int = -1
    
    private var rotationObserver = 1 {
        
        didSet {
            guard let gameScene = gameScene else {return}
            if currentDeviceOrientation == DeviceOrientation.landscape {
                let action = SKAction.rotate(byAngle: CGFloat.pi/2, duration: 0)
                gameScene.cameraNode.setScale(PincherMate.mapLandscapeMin.val)
                rotateCharactersInLandscapeMode()
                
                if startedAs == DeviceOrientation.portriat {
                    gameScene.mapCreator.normalMap.run(action)
                    gameScene.mapCreator.rotatedMap.run(action)
                    gameScene.mapCreator.normalMap.isHidden = true
                    gameScene.mapCreator.rotatedMap.isHidden = false
                    gameScene.mapCreator.isRotated = true
                } else {
                    gameScene.mapCreator.normalMap.run(action)
                    gameScene.mapCreator.rotatedMap.run(action)
                    gameScene.mapCreator.normalMap.isHidden = false
                    gameScene.mapCreator.rotatedMap.isHidden = true
                    gameScene.mapCreator.isRotated = false
                }
            } else if currentDeviceOrientation == DeviceOrientation.portriat {
                let action = SKAction.rotate(byAngle: -CGFloat.pi/2, duration: 0)
                gameScene.cameraNode.setScale(PincherMate.mapPortraitMin.val)
                rotateCharactersInPortraitMode()

                if startedAs == DeviceOrientation.portriat {
                    gameScene.mapCreator.normalMap.run(action)
                    gameScene.mapCreator.rotatedMap.run(action)
                    gameScene.mapCreator.normalMap.isHidden = false
                    gameScene.mapCreator.rotatedMap.isHidden = true
                    gameScene.mapCreator.isRotated = false
                } else {
                    gameScene.mapCreator.normalMap.run(action)
                    gameScene.mapCreator.rotatedMap.run(action)
                    gameScene.mapCreator.normalMap.isHidden = true
                    gameScene.mapCreator.rotatedMap.isHidden = false
                    gameScene.mapCreator.isRotated = true
                }
            }
            guard let player: GameUnit = gameScene.mapCreator.player else {return}
            gameScene.cameraNode.position = player.position
            guard let viewController = gameScene.viewController else {return}
            viewController.controller.determineValidNextMoves(playerLocation: player.position)
        }
    }
    
    private func rotateCharactersInLandscapeMode() {
        // Player
        guard let gameScene = gameScene else {return}
        guard let player: GameUnit = gameScene.mapCreator.player else {return}
        var point = player.position - gameScene.mapCreator.cameraCenter()
        point = rotateNintyDegrees(point)
        if startedAs == DeviceOrientation.portriat {point = CGPoint(x: -point.x, y: -point.y)}
        point = point + gameScene.mapCreator.cameraCenter()
        gameScene.mapCreator.player?.nonActionMove(to: point)
        
        // Enemies
        for i in 0 ..< gameScene.mapCreator.enemies.count {
            var point = gameScene.mapCreator.enemies[i].position - gameScene.mapCreator.cameraCenter()
            point = rotateNintyDegrees(point)
            if startedAs == DeviceOrientation.portriat {point = CGPoint(x: -point.x, y: -point.y)}
            point = point + gameScene.mapCreator.cameraCenter()
            gameScene.mapCreator.enemies[i].nonActionMove(to: point)
        }
    }
    
    private func rotateCharactersInPortraitMode() {
        // Player
        guard let gameScene = gameScene else {return}
        guard let player: GameUnit = gameScene.mapCreator.player else {return}
        var point = player.position - gameScene.mapCreator.cameraCenter()
        point = rotateNintyDegrees(point)
        if startedAs == DeviceOrientation.landscape {point = CGPoint(x: -point.x, y: -point.y)}
        point = point + gameScene.mapCreator.cameraCenter()
        gameScene.mapCreator.player?.nonActionMove(to: point)
        
        // Enemies
        for i in 0 ..< gameScene.mapCreator.enemies.count {
            var point = gameScene.mapCreator.enemies[i].position - gameScene.mapCreator.cameraCenter()
            point = rotateNintyDegrees(point)
            if startedAs == DeviceOrientation.landscape {point = CGPoint(x: -point.x, y: -point.y)}
            point = point + gameScene.mapCreator.cameraCenter()
            gameScene.mapCreator.enemies[i].nonActionMove(to: point)
        }
    }
    
    private func rotateNintyDegrees(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: point.y, y: -point.x)
    }
    
    init(gameScene: GameScene!) {
        self.gameScene = gameScene
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        lastFrameX = gameScene.frameMidX
    }
    
    @objc func rotated() {
        guard let gameScene = gameScene else {return}
        if lastFrameX == gameScene.frameMidX {return}
        lastFrameX = gameScene.frameMidX
        if UIDevice.current.orientation == .portraitUpsideDown && UIDevice.current.userInterfaceIdiom == .phone {
            return
        }
    
        if startedAs == -1 {
            if gameScene.frameMidX < gameScene.frameMidY {
                startedAs = DeviceOrientation.landscape
                //gameScene.mapCreator.rotatedMap.position = CGPoint(x: gameScene.mapCreator.getEdgeLength() * gameScene.mapCreator.getRow(), y: 0)
                gameScene.mapCreator.rotatedMap.run(SKAction.rotate(byAngle: CGFloat.pi, duration: 0))
            } else {
                startedAs = DeviceOrientation.portriat
            }
        }

        if UIDevice.current.orientation.isLandscape {
            currentDeviceOrientation = DeviceOrientation.landscape
        } else if UIDevice.current.orientation.isPortrait {
            currentDeviceOrientation = DeviceOrientation.portriat
            //keepPortraitViewCameraInRange()
        }
        rotationObserver += 1
    }
    
    private func keepPortraitViewCameraInRange() {
        guard let gameScene = gameScene else {return}
        guard let camera = gameScene.camera else { return } // The camera has a weak reference, so test it
        let recognizer = UIPinchGestureRecognizer()
        let locationInView = recognizer.location(in: gameScene.view)
        let location = gameScene.convertPoint(fromView: locationInView)

        let deltaScale = (recognizer.scale - 1.0)*2
        let convertedScale = recognizer.scale - deltaScale
        let newScale = camera.xScale*convertedScale
        
        if (newScale >= PincherMate.mapLandscapeMin.val+0.2) {
            camera.setScale(PincherMate.mapLandscapeMin.val+0.1)
        }
        
        //zoom around touch point rather than center screen
        let locationAfterScale = gameScene.convertPoint(fromView: locationInView)
        let locationDelta = location - locationAfterScale
        let newPoint = camera.position + locationDelta
        camera.position = newPoint
        
        //reset value for next time
        recognizer.scale = 1.0
    }
}
