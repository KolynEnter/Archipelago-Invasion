//
//  AccountingViewController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/23/23.
//

import UIKit
import SpriteKit
import GameplayKit

// the view controller is for inside the house

class TownViewController: UIViewController {
    
    private var townScene: TownScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            
            // Load the SKScene from 'TownScene.sks'
            if let scene = SKScene(fileNamed: "TownScene") {
                townScene = scene as? TownScene
                // Set the scale mode to scale to fit the window
                townScene.scaleMode = .aspectFill
                if OrientationChecker().portraitTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.portriat
                } else if OrientationChecker().landscapeTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.landscape
                }
                // Present the scene
                view.presentScene(townScene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
