//
//  GameView.swift
//  Archipelago
//
//  Created by Jianxin Lin on 3/10/23.
//

import Foundation
import UIKit
import SpriteKit

struct GameView: GameViewProtocol {
    
    private weak var controller: GameController!
    
    init(controller: GameController) {
        self.controller = controller
    }
    
    func hideAllMenuButtons() {
        controller.viewController.unitsButton.isHidden = true
        controller.viewController.inventoryButton.isHidden = true
        controller.viewController.travelButton.isHidden = true
        controller.viewController.bestiaryButton.isHidden = true
        controller.viewController.achievementButton.isHidden = true
        controller.viewController.mainButton.isHidden = true
        controller.viewController.enterHouseButton.isHidden = true
    }
    
    func showAllMenuButtons() {
        controller.viewController.unitsButton.isHidden = false
        controller.viewController.inventoryButton.isHidden = false
        controller.viewController.travelButton.isHidden = false
        controller.viewController.bestiaryButton.isHidden = false
        controller.viewController.achievementButton.isHidden = false
        controller.viewController.mainButton.isHidden = false
    }
    
    func hideAllMoveButtons() {
        controller.viewController.moveUpButton.isHidden = true
        controller.viewController.moveDownButton.isHidden = true
        controller.viewController.moveLeftButton.isHidden = true
        controller.viewController.moveRightButton.isHidden = true
        controller.viewController.enterHouseButton.isHidden = true
    }
    
    func showAllMoveButtons() {
        controller.viewController.moveUpButton.isHidden = false
        controller.viewController.moveDownButton.isHidden = false
        controller.viewController.moveLeftButton.isHidden = false
        controller.viewController.moveRightButton.isHidden = false
    }
}
