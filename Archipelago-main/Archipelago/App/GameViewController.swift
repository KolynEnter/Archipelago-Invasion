//
//  GameViewController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/12/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet var gameMenuButton: UIButton!
    @IBOutlet var unitsButton: UIButton!
    @IBOutlet var inventoryButton: UIButton!
    @IBOutlet var travelButton: UIButton!
    @IBOutlet var bestiaryButton: UIButton!
    @IBOutlet var achievementButton: UIButton!
    @IBOutlet var mainButton: UIButton!
    
    @IBOutlet var moveUpButton: UIButton!
    @IBOutlet var moveDownButton: UIButton!
    @IBOutlet var moveLeftButton: UIButton!
    @IBOutlet var moveRightButton: UIButton!
    @IBOutlet weak var enterHouseButton: UIButton! // show when on house tile & on town
    
    var controller: GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        if controller == nil {setController()}
        controller.warmGameView()
    }
    
    func setController() {
        controller = GameController(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        controller.viewWillAppear(animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        controller.viewDidDisappear(animated)
        super.viewDidDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        controller.viewWillTransition(to: size, with: coordinator)
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
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        controller.dismiss(animated: flag, completion: completion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send level enemy data to Battle
        controller.prepare(for: segue, sender: sender)
    }
    
    @IBAction func pressGameMenu(_ sender: Any) {
        controller.pressGameMenu(sender)
    }
    
    @IBAction func moveUpPressed(_ sender: Any) {
        controller.moveUpPressed(sender)
    }
    
    @IBAction func moveDownPressed(_ sender: Any) {
        controller.moveDownPressed(sender)
    }
    
    @IBAction func moveLeftPressed(_ sender: Any) {
        controller.moveLeftPressed(sender)
    }
    
    @IBAction func moveRightPressed(_ sender: Any) {
        controller.moveRightPressed(sender)
    }
    
    @IBAction func enterHouseButtonPressed(_ sender: Any) {
        controller.enterHouseButtonPressed(sender)
    }
    
    deinit {
           print("\n THE SCENE \(type(of:self)) WAS REMOVED FROM MEMORY (DEINIT) \n")
    }
}
