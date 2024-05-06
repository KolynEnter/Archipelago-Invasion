//
//  MainScene.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/7/23.
//

import SpriteKit
import GameplayKit


class MainScene: TouchScene {
    
    let tapper = MainTapper()
    weak var viewController: MainViewController!
    
    var rotationObserver = 1 {
        didSet {
            
        }
    }
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        super.didMove(to: view)
        self.name = "MainScene"
        cameraNode = camera!
    }
    
    func nodesTapped(at point: CGPoint) {
        tapper.nodesTapped(mainScene: self, at: point)
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
    
    deinit {
           print("\n THE SCENE \(type(of:self)) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
}
