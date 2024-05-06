//
//  GameViewController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/23/22.
//

import UIKit
import SpriteKit
import GameplayKit

class MainViewController: UIViewController {
    
    private var mainScene: MainScene!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var bigTitle: UILabel!
    
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        if let view = self.view as! SKView? {
            let name = "MainScene"
            if let scene = SKScene(fileNamed: name) {
                mainScene = scene as? MainScene
                // Set the scale mode to scale to fit the window
                mainScene.scaleMode = .aspectFill
                if OrientationChecker().portraitTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.portriat
                } else if OrientationChecker().landscapeTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.landscape
                }
                // Present the scene
                view.presentScene(mainScene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
        }
        self.modalPresentationStyle = .fullScreen
        
        if !AppDelegate.isFirstLaunch {
            let myNormalAttributedTitle = NSAttributedString(string: "Continue",
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            startButton.setAttributedTitle(myNormalAttributedTitle, for: .normal)
            logo.isHidden = true
        } else {
            bigTitle.isHidden = true
            startButton.isHidden = true
            optionsButton.isHidden = true
            logo.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.logo.isHidden = false
            })
            UIImageView.animate(withDuration: 2, delay: 2.5, options: .curveEaseInOut, animations: {self.logo.alpha = 0.0} )
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5, execute: {
                self.bigTitle.isHidden = false
                self.startButton.isHidden = false
                self.optionsButton.isHidden = false
            })
        }
        
        changeToAppFont(forLabel: bigTitle)
        changeToAppFont(forButton: startButton)
        changeToAppFont(forButton: optionsButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let viewControllers = navigationController?.viewControllers,
        let index = viewControllers.firstIndex(of: self) else { return }
        navigationController?.viewControllers.remove(at: index)
        mainScene = nil
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        mainScene.rotated()
        
        /*
         super.viewWillTransition(to:size, with: coordinator)
         let before = self.view.window?.windowScene?.interfaceOrientation
         coordinator.animate(alongsideTransition: nil) { _ in
             let after = self.view.window?.windowScene?.interfaceOrientation
             if before != after {
                 // yep, it's a rotation ...
             }
         }
         */
    }
    
    @IBAction func startckButtonClicked(_ sender: Any) {
        if AppDelegate.isFirstLaunch  {
            AppDelegate.isFirstLaunch = false
            self.performSegue(withIdentifier: "MainToGame", sender: nil)
        } else {
            guard let viewControllers = navigationController?.viewControllers,
            let index = viewControllers.firstIndex(of: self) else { return }
            navigationController?.viewControllers.remove(at: index)
        }
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
    
    deinit {
           print("\n THE SCENE \(type(of:self)) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
}
