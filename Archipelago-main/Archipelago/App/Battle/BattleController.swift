//
//  BattleController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/11/23.
//

import Foundation
import UIKit
import SpriteKit

class BattleController: BattleControllerProtocol {
    weak var viewController: BattleViewController!
    private var model: BattleModel!
    private var battleView: BattleView!
    
    init(viewController: BattleViewController) {
        self.viewController = viewController
        model = BattleModel()
    }
    
    func warmBattleView() {
        self.battleView = BattleView(controller: self)
        
        if let view = viewController.view as! SKView? {
            let name = "BattleScene"
            if let scene = SKScene(fileNamed: name) {
                model.battleScene = scene as? BattleScene
                // Set the scale mode to scale to fit the window
                model.battleScene.scaleMode = .aspectFill
                model.battleScene.viewController = viewController
                if OrientationChecker().portraitTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.portriat
                } else if OrientationChecker().landscapeTrue(view: view) {
                    currentDeviceOrientation = DeviceOrientation.landscape
                }
                // Present the scene
                view.presentScene(model.battleScene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = true
            view.showsNodeCount = true
            view.shouldCullNonVisibleNodes = true
        }
        viewController.escapeButton.isHidden = true
        viewController.accountingTitle.isHidden = true
        viewController.accountingConfirm.isHidden = true
        viewController.materialTable.isHidden = true
        
        viewController.materialTable.delegate = viewController
        viewController.materialTable.dataSource = viewController
        viewController.materialTable.backgroundColor = .clear
        viewController.materialTable.showsHorizontalScrollIndicator = false
        viewController.materialTable.showsVerticalScrollIndicator = false
        viewController.materialTable.rowHeight = 32
        
        changeToAppFont(forLabel: viewController.accountingTitle)
        changeToAppFont(forButton: viewController.accountingConfirm)
        changeToAppFont(forButton: viewController.escapeButton)
    }
    
    func viewWillAppear(_ animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
    }
    
    func viewDidDisappear(_ animated: Bool) {
        guard let viewControllers = viewController.navigationController?.viewControllers,
        let index = viewControllers.firstIndex(of: viewController) else { return }
        viewController.navigationController?.viewControllers.remove(at: index)
        model.battleScene = nil
    }
    
    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            currentDeviceOrientation = DeviceOrientation.landscape
        } else if UIDevice.current.orientation.isPortrait {
            currentDeviceOrientation = DeviceOrientation.portriat
        }
        model.battleScene.rotated()
    }
    
    func goToAccounting(battleResult: BattleResult) {
        if battleResult == .Win {
            viewController.accountingTitle.text = "Well Done."
            // load the material dropped by enemies to accounting
            model.accountingMaterials = [BattleManager.MaterialAndNumber]()
            model.accountingMaterials.append(BattleManager.MaterialAndNumber(name: "You gained: ", number: -1))
            let award = model.battleScene.battleManager.loadWinningMaterials()
            var cashNumber = 0
            var soulNumber = 0
            for material in award {
                if material.number != 0 {
                    if material.name == "Cash" {
                        cashNumber = material.number
                        continue
                    }
                    if material.name == "Soul" {
                        soulNumber = material.number
                        continue
                    }
                    model.accountingMaterials.append(BattleManager.MaterialAndNumber(name: material.name, number: material.number))
                }
            }
            model.accountingMaterials.insert(BattleManager.MaterialAndNumber(name: "Cash", number: cashNumber), at: 1)
            model.accountingMaterials.insert(BattleManager.MaterialAndNumber(name: "Soul", number: soulNumber), at: 2)
            viewController.materialTable.reloadData()
        } else if battleResult == .Lose {
            viewController.accountingTitle.text = "Nice Attempt."
            // load the material dropped by enemies to accounting
            model.accountingMaterials = [BattleManager.MaterialAndNumber]()
            viewController.materialTable.reloadData()
        } else if battleResult == .Escape {
            model.playerUsedEscape = true
            viewController.accountingTitle.text = "You escaped."
            // load the material dropped by enemies to accounting
            model.accountingMaterials = [BattleManager.MaterialAndNumber]()
            viewController.materialTable.reloadData()
        }
        
        // Win: back to map
        // Escape: back to map
        // Lose: back to town
        var myNormalAttributedTitle: NSAttributedString!
        if battleResult == .Win || battleResult == .Escape {
            myNormalAttributedTitle = NSAttributedString(string: "Back to map",
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        } else {
            myNormalAttributedTitle = NSAttributedString(string: "Back to town",
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        
        
        viewController.accountingConfirm.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        changeToAppFont(forButton: viewController.accountingConfirm)
        
        viewController.escapeButton.isHidden = true
        viewController.turnSignButton.isHidden = true
        model.battleScene.settingBackground.isHidden = false
        model.settingIsOpened = true
        viewController.settingButton.isHidden = true
        
        viewController.accountingTitle.isHidden = false
        viewController.accountingConfirm.isHidden = false
        viewController.materialTable.isHidden = false
        model.battleScene.statsBar.isHidden = true
    }
    
    func turnSignIsPressed(_ sender: Any) {
        if model.battleScene.getCurrentTurn() == TurnSigns.END {
            model.battleScene.setCurrentTurn(to: TurnSigns.ENEMY)
        }
    }
    
    func accountingConfirmPressed(_ sender: Any) {
        // if win, go back to map
        guard let viewControllers = viewController.navigationController?.viewControllers,
              let index = viewControllers.firstIndex(of: viewController) else { return }
        for i in 0 ..< viewControllers.count {
            guard let controller = viewControllers[i] as? GameViewController else {continue}
            controller.controller.setInBattleNow(to: false)
            controller.controller.setAnimationFinished(to: true)
            controller.controller.setPlayerUsedEscape(to: model.playerUsedEscape)
        }
        viewController.navigationController?.viewControllers.remove(at: index)

        // if lose, go back to town
    }
    
    func escapeButtonPressed(_ sender: Any) {
        // Go to accounting
        goToAccounting(battleResult: .Escape)
        viewController.accountingTitle.text = "You escaped."
    }
    
    func settingIsOpened() -> Bool {
        return model.settingIsOpened
    }
    
    func setSettingBackgroundHidden(to val: Bool) {
        model.battleScene.settingBackground.isHidden = val
    }
    
    func setSettingIsOpen(to val: Bool) {
        model.settingIsOpened = val
    }
    
    func getAccountingMaterials() -> [BattleManager.MaterialAndNumber] {
        return model.accountingMaterials
    }
    
    func settingIsPressed(_ sender: Any) {
        battleView.settingIsPressed(sender)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return battleView.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func setLevelEnemyData(to val: LevelEnemyData) {
        model.levelEnemyData = val
    }
    
    func setTriggerBattleEnemyIndex(to val: Int) {
        model.triggerBattleEnemyIndex = val
    }
    
    func getTriggerBattleEnemyIndex() -> Int{
        return model.triggerBattleEnemyIndex
    }
    
    func getEnemyInLeveEnemyData(withIndex index: Int) -> [LevelEnemyData.Enemy] {
        return model.levelEnemyData.level[index].enemy
    }
    
    func getLootInLevelEnemyData(withIndex index: Int) -> [Int] {
        return model.levelEnemyData.level[index].loot
    }
}
