//
//  GameController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/10/23.
//

import Foundation
import SpriteKit

class GameController: GameControllerProtocol {
    weak var viewController: GameViewController!
    private var model: GameModel!
    private var gameView: GameView!
    
    init(viewController: GameViewController) {
        self.viewController = viewController
        self.model = GameModel()
    }
    
    func warmGameView() {
        self.gameView = GameView(controller: self)
        
        if let view = viewController.view as! SKView? {
            if let scene = SKScene(fileNamed: "GameScene") {
                model.gameScene = (scene as? GameScene)!
                model.gameScene.scaleMode = .aspectFill
                model.gameScene.viewController = viewController
                
                if OrientationChecker().portraitTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.portriat
                } else if OrientationChecker().landscapeTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.landscape
                }
                // Present the scene
                view.presentScene(model.gameScene)
            }
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.shouldCullNonVisibleNodes = true
        }
        
        gameView.hideAllMenuButtons()
        changeToAppFont(forButton: viewController.gameMenuButton)
        changeToAppFont(forButton: viewController.unitsButton)
        changeToAppFont(forButton: viewController.inventoryButton)
        changeToAppFont(forButton: viewController.travelButton)
        changeToAppFont(forButton: viewController.bestiaryButton)
        changeToAppFont(forButton: viewController.achievementButton)
        changeToAppFont(forButton: viewController.mainButton)
        changeToAppFont(forButton: viewController.enterHouseButton)
    }
    
    func moveUpPressed(_ sender: Any) {
        if !model.nextUpValid {return}
        move(dx: 0, dy: 1)
    }
    
    func moveDownPressed(_ sender: Any) {
        if !model.nextDownValid {return}
        move(dx: 0, dy: -1)
    }
    
    func moveLeftPressed(_ sender: Any) {
        if !model.nextLeftValid {return}
        move(dx: -1, dy: 0)
    }
    
    func moveRightPressed(_ sender: Any) {
        if !model.nextRightValid {return}
        move(dx: 1, dy: 0)
    }
    
    func move(dx: Int, dy: Int) {
        if model.inBattleNow {return}
        if !model.animationFinished {return}
        model.animationFinished = false
        guard let player: GameUnit = model.gameScene.mapCreator.player else {return}
        let x = player.position.x
        let y = player.position.y
        let position = CGPoint(x: x + CGFloat(dx) * CGFloat(model.gameScene.mapCreator.getEdgeLength()),
                               y: y + CGFloat(dy) * CGFloat(model.gameScene.mapCreator.getEdgeLength()))
        let action = SKAction.move(to: position, duration: TimeController.regularCameraMovement)
        model.gameScene.mapCreator.player?.position = position
        model.gameScene.cameraNode.run(action)
        processIfPlayerIsOnEnterable()
        model.gameScene.mapCreator.monstersWalk()
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.regularCameraMovement, execute: {
            self.model.gameScene.mapCreator.processPlayerHiddenTiles()
            if self.checkIfBattleStart(playerPosition: position) {return}
            if self.checkIfPlayerIsOnPortal() {return}
        })
    }
    
    func pressGameMenu(_ sender: Any) {
        if !model.isMenuOpened {
            gameView.showAllMenuButtons()
            gameView.hideAllMoveButtons()
            viewController.gameMenuButton.setImage(UIImage(named: "Resume"), for: .normal)
            model.isMenuOpened = true
            model.gameScene.settingBackground.isHidden = false
        } else {
            gameView.hideAllMenuButtons()
            gameView.showAllMoveButtons()
            viewController.gameMenuButton.setImage(UIImage(named: "Pause"), for: .normal)
            model.isMenuOpened = false
            model.gameScene.settingBackground.isHidden = true
        }
    }
    
    func processIfPlayerIsOnEnterable() {
        if model.gameScene.mapCreator.isPlayerOnEnterableTile() && model.isOnTown {
            viewController.enterHouseButton.isHidden = false
        } else {
            viewController.enterHouseButton.isHidden = true
        }
    }
    
    func enterHouseButtonPressed(_ sender: Any) {
        if model.gameScene.mapCreator.isPlayerOnCampTile() {
            // segue to map selection
            viewController.performSegue(withIdentifier: "GameToMap", sender: nil)
        }
    }
    
    func checkIfPlayerIsOnPortal() -> Bool {
        if model.gameScene.mapCreator.isPlayerOnPortal() {
            loadNewMap()
            model.nextUpValid = true
            model.nextDownValid = true
            model.nextLeftValid = true
            model.nextRightValid = true
            model.animationFinished = true
            return true
        }
        model.determineValidNextMoves(playerLocation: model.gameScene.mapCreator.player.position)
        model.animationFinished = true
        return false
    }
    
    func checkIfBattleStart(playerPosition: CGPoint) -> Bool {
        // check if player is in monster's attacking range, set inBattleNow true if yes
        model.gameScene.mapCreator.checkIfPlayerInAttackRange()
        if model.inBattleNow {
            // Battle triggered!, wait a while then go to battle scene
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.segueToBattleScene()
            })
            model.determineValidNextMoves(playerLocation: playerPosition)
            model.animationFinished = true
            return true
        }
        // No battle
        model.determineValidNextMoves(playerLocation: playerPosition)
        model.animationFinished = true
        return false
    }
    
    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        model.gameScene.mapCreator.player = nil
        model.gameScene.mapCreator.enemies = []
        model.gameScene = nil
    }
    
    func loadNewMap() {
        let head = HeadStyleTransition(picture: "Dummy head")
        head.addAllImages(view: viewController.view)
        head.slidingImage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 - TimeController.regularCameraMovement, execute: {
            self.newMapView()
        })
    }
    
    private func newMapView() {
        viewController.performSegue(withIdentifier: "GameToGame", sender: nil)
        
        guard let viewControllers = viewController.navigationController?.viewControllers,
              let index = viewControllers.firstIndex(of: viewController) else { return }
        
        // advance current level
        //model.currentLevel = model.gameScene.currentLevel + 1
        if let newGameViewController = viewControllers[1] as? GameViewController {
            newGameViewController.setController()
            newGameViewController.controller.setCurrentLevel(to: model.gameScene.currentLevel + 1)
        }
        viewController.navigationController?.viewControllers.remove(at: index)
        dismiss(animated: false, completion: nil)
    }
    
    func segueToBattleScene() {
        let head = HeadStyleTransition(picture: "Ape head")
        head.addAllImages(view: viewController.view)
        head.slidingImage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2 - TimeController.regularCameraMovement, execute: {
            self.viewController.performSegue(withIdentifier: "GameToBattle", sender: nil)
        })
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // send level enemy data to Battle
        if segue.identifier == "GameToBattle" {
            guard let viewController = segue.destination as? BattleViewController else {return}
            viewController.setController()
            viewController.controller.setLevelEnemyData(to: model.gameScene.levelEnemyDataLoader.levelEnemyDatas[model.gameScene.currentLevel])
            viewController.controller.setTriggerBattleEnemyIndex(to: model.triggerBattleEnemyIndex)
            for i in 0 ..< model.gameScene.mapCreator.enemies.count {
                if model.gameScene.mapCreator.enemies[i].getOriginalAssignedIndex() == model.triggerBattleEnemyIndex {
                    model.gameScene.mapCreator.removeEnemyByIndex(i)
                    return
                }
            }
        }
    }
    
    func viewWillAppear(_ animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
        if model.playerUsedEscape {
            model.gameScene.mapCreator.teleportPlayerToCamp()
            model.playerUsedEscape = false
            model.gameScene.mapCreator.player.isBeingHidden = false
            model.gameScene.mapCreator.player.getModel().colorBlendFactor = 0
        }
    }
    
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if OrientationChecker().portraitTrue(view: viewController.view as? SKView) {
            currentDeviceOrientation = DeviceOrientation.portriat
        } else if OrientationChecker().landscapeTrue(view: viewController.view as? SKView) {
            currentDeviceOrientation = DeviceOrientation.landscape
        }
        
        model.gameScene.rotated()
    }
    
    func viewDidDisappear(_ animated: Bool) {
        /*
        guard let viewControllers = navigationController?.viewControllers,
        let index = viewControllers.firstIndex(of: self) else { return }
        
        guard viewControllers[1] is NeedToCleanGameBoard else {return}
        navigationController?.viewControllers.remove(at: index)
        gameScene.mapCreator.player = nil
        gameScene.mapCreator.enemies = []
        gameScene = nil
         */
    }
    
    func determineValidNextMoves(playerLocation: CGPoint) {
        return model.determineValidNextMoves(playerLocation: playerLocation)
    }
    
    func getCurrentLevel() -> Int {
        return model.currentLevel
    }
    
    func setCurrentLevel(to val: Int) {
        model.currentLevel = val
    }
    
    func isOnTown() -> Bool {
        return model.isOnTown
    }
    
    func isMenuOpened() -> Bool {
        return model.isMenuOpened
    }
    
    func setInBattleNow(to val: Bool) {
        model.inBattleNow = val
    }
    
    func setAnimationFinished(to val: Bool) {
        model.animationFinished = val
    }
    
    func setPlayerUsedEscape(to val: Bool) {
        model.playerUsedEscape = val
    }
    
    func goToTown() {
        model.goToTown()
    }
    
    func leaveTown() {
        model.leaveTown()
    }
    
    func setTriggerBattleEnemyIndex(to val: Int) {
        model.triggerBattleEnemyIndex = val
    }
}
