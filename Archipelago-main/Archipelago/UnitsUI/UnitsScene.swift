//
//  UnitsScene.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/14/23.
//

import SpriteKit
import GameplayKit


class UnitsScene: TouchScene {
    
    var tapper: UnitsTapper!
    
    var rotationObserver = 1 {
        didSet {
            
        }
    }
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        super.didMove(to: view)
        self.name = "UnitsScene"
        tapper = UnitsTapper(unitsScene: self)
        cameraNode = camera!
    }
    
    
    func nodesTapped(at point: CGPoint) {
        tapper.nodesTapped(at: point)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        touchesMoved(touches, with: event)
        let distance = originalTouch.manhattanDistance(to: lastTouch)
        if distance < 44 {
            nodesTapped(at: touch.location(in: self))
        }
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation == .portraitUpsideDown && UIDevice.current.userInterfaceIdiom == .phone {
            return
        }

        rotationObserver += 1
    }
}
