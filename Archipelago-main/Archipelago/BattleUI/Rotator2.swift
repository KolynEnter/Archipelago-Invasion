//
//  Rotator.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/27/23.
//

import SpriteKit

class BattleSceneRotator {
    weak var battleScene: BattleScene?
    var lastFrameX: CGFloat = 0 // a hacky way to fix a serious rotation bug

    var rotationObserver = 1 {
        didSet {
            guard let battleScene = battleScene else {return}
            battleScene.rightEdgeNode.position = CGPoint(x: battleScene.frameMidX, y: 0)
            battleScene.upEdgeNode.position = CGPoint(x: 0, y: battleScene.frameMidY)
        }
    }
    
    init(battleScene: BattleScene) {
        self.battleScene = battleScene
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        lastFrameX = battleScene.frameMidX
    }
    
    @objc func rotated() {
        guard let battleScene = battleScene else {return}
        if lastFrameX == battleScene.frameMidX {return}
        lastFrameX = battleScene.frameMidX
        if UIDevice.current.orientation == .portraitUpsideDown && UIDevice.current.userInterfaceIdiom == .phone {
            return
        }
        
        if UIDevice.current.orientation.isLandscape {
            battleScene.cameraNode.setScale(battleScene.cameraNode.xScale+2.5)
            currentDeviceOrientation = DeviceOrientation.landscape
        } else if UIDevice.current.orientation.isPortrait {
            battleScene.cameraNode.setScale(battleScene.cameraNode.xScale-2.5)
            currentDeviceOrientation = DeviceOrientation.portriat
            keepPortraitViewCameraInRange()
        }
        if battleScene.floatingPanels.count > 0 {
            battleScene.floatingPanels.forEach {$0.removeFromParent()}
        }
        rotationObserver += 1
    }
    
    private func keepPortraitViewCameraInRange() {
        guard let battleScene = battleScene else {return}
        guard let camera = battleScene.camera else { return } // The camera has a weak reference, so test it
        let recognizer = UIPinchGestureRecognizer()
        let locationInView = recognizer.location(in: battleScene.view)
        let location = battleScene.convertPoint(fromView: locationInView)

        let deltaScale = (recognizer.scale - 1.0)*2
        let convertedScale = recognizer.scale - deltaScale
        let newScale = camera.xScale*convertedScale
        camera.setScale(newScale)
        
        //zoom around touch point rather than center screen
        let locationAfterScale = battleScene.convertPoint(fromView: locationInView)
        let locationDelta = location - locationAfterScale
        var newPoint = camera.position + locationDelta
        
        let mapCreator = battleScene.mapCreator
        let el: CGFloat = CGFloat(mapCreator.getEdgeLength())
        let row: CGFloat = CGFloat(mapCreator.getRow())
        let col: CGFloat = CGFloat(mapCreator.getCol())
        if newPoint.x < 0 {
            newPoint.x = 0
        }
        if newPoint.x > el * row {
            newPoint.x = el * row
        }
        if newPoint.y < 0 {
            newPoint.y = 0
        }
        if newPoint.y > el * col {
            newPoint.y = el * col
        }
        
        camera.position = newPoint
        
        //reset value for next time
        recognizer.scale = 1.0
    }
}
