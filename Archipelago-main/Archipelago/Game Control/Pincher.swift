//
//  Pincher.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/25/22.
//

import SpriteKit

class Pincher {
    
    func pinch(_ recognizer:UIPinchGestureRecognizer, scene: TouchScene) {
        guard let camera = scene.camera else { return } // The camera has a weak reference, so test it

        //cache location prior to scaling
        let locationInView = recognizer.location(in: scene.view)
        let location = scene.convertPoint(fromView: locationInView)
        
        if recognizer.state == .changed {
            let deltaScale = (recognizer.scale - 1.0)*2
            let convertedScale = recognizer.scale - deltaScale
            let newScale = camera.xScale*convertedScale
            
            if currentDeviceOrientation == 1 {
                if newScale < PincherMate.mapLandscapeMax.val && newScale > PincherMate.mapLandscapeMin.val {
                    scene.oldCameraScale = camera.xScale
                    scene.currentCameraScale = newScale
                    camera.setScale(newScale)
                }
            } else {
                if newScale < PincherMate.mapPortraitMax.val && newScale > PincherMate.mapPortraitMin.val {
                    scene.oldCameraScale = camera.xScale
                    scene.currentCameraScale = newScale
                    camera.setScale(newScale)
                }
            }
            
            //zoom around touch point rather than center screen
            let locationAfterScale = scene.convertPoint(fromView: locationInView)
            let locationDelta = location - locationAfterScale
            let newPoint = camera.position + locationDelta
            camera.position = newPoint
            
            //reset value for next time
            recognizer.scale = 1.0
        }
    }
}
