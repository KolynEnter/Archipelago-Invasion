//
//  Tapper.swift
//  Archipelago
//
//  Created by Jianxin Lin on 8/25/22.
//

import SpriteKit

class BattleTapper {
    
    private weak var battleScene: BattleScene?
    private var storedUser: Unit?
    private var storedTarget: Unit?
    private var cameraResetCounter = 0
    private var prevBuffIcon: BuffIconNode!
    var turnController: TurnController!
    var mover: Mover!
    var selectedItem: SKSpriteNode? {
        didSet {
            selectedItemChanged()
        }
    }
    
    init(battleScene: BattleScene) {
        self.battleScene = battleScene
        turnController = TurnController(battleScene: battleScene)
        mover = Mover(battleScene: battleScene, mapCreator: battleScene.mapCreator)
    }
    
    func nodesTapped(battleScene: BattleScene, at point: CGPoint) {
        guard let viewController = battleScene.viewController else {return}
        if viewController.controller.settingIsOpened() {return}
        tapThings(point: point)
    }
    
    private func tapThings(point: CGPoint) {
        let arr = potentialSelectedNodeArray(point: point)
        
        if arr[2] != nil { // floating button is not nil
            guard let button = arr[2] as? FloatingButton else {return}
            thereIsButton(buttonName: button.name ?? "Unknown")
            cameraResetCounter = 0
        } else if arr[3] != nil { // buffIcon is not nil
            buffIconIsNotNull(tappedBuffIcon: arr[3] as! BuffIconNode)
            cameraResetCounter = 0
        } else if arr[0] != nil { // move is not nil
            moveIsNotNull(tappedMove: arr[0] as! SKNode)
            cameraResetCounter = 0
        } else if arr[1] != nil { // unit is not nil
            unitIsNotNull(tappedUnit: arr[1] as! Unit)
            cameraResetCounter = 0
        } else {
            nothingIsTapped()
        }
    }
    
    private func potentialSelectedNodeArray(point: CGPoint) -> [Any?] {
        var arr = [Any?]()
        guard let battleScene = battleScene else {return []}
        let tappedNodes = battleScene.nodes(at: point)
        var tappedMove: SKNode!
        var tappedUnit: Unit!
        var tappedFloatingButton: FloatingButton!
        var tappedBuffIcon: BuffIconNode!
        
        for node in tappedNodes {
            if node is Unit {
                tappedUnit = node as? Unit
            } else if node is FloatingButton {
                tappedFloatingButton = node as? FloatingButton
            } else if node is BuffIconNode {
                tappedBuffIcon = node as? BuffIconNode
            } else {
                if node.name == "move" {
                    tappedMove = node
                }
            }
        }
        
        arr.append(tappedMove)
        arr.append(tappedUnit)
        arr.append(tappedFloatingButton)
        arr.append(tappedBuffIcon)
        
        return arr
    }
    
    private func buffIconIsNotNull(tappedBuffIcon: BuffIconNode) {
        // there can only be one buff icon showing at a time
        if prevBuffIcon != nil {
            if prevBuffIcon.position.equalTo(tappedBuffIcon.position) && !tappedBuffIcon.isDescriptionPanelHidden() {
                prevBuffIcon.hideDescriptionPanel()
                tappedBuffIcon.hideDescriptionPanel()
                return
            }
            prevBuffIcon.hideDescriptionPanel()
        }
        tappedBuffIcon.showDescriptionPanel()
        prevBuffIcon = tappedBuffIcon
    }
    
    private func moveIsNotNull(tappedMove: SKNode) {
        guard let battleScene = battleScene else {return}
        guard let selectedUnit = selectedItem as? Unit else {return} // your unit
        // if you have a controlled unit, you must only use that unit
        if turnController.controlledUnitBattleIndex != -1 && !selectedUnit.cannotMove {
            if selectedUnit.battleIndex != turnController.controlledUnitBattleIndex {return}
        }
        // you cannot controller a unit that is not yours
        else if !selectedUnit.isAlly || !selectedUnit.isAlive || selectedUnit.cannotMove {return}
        let tappedUnits = battleScene.battleManager.units.itemAt(position: tappedMove.position) // possibly enemy
        
        if tappedUnits.count == 0 {
            // and tapped a blue square
            // before moving a unit, check if the player has moved
            if turnController.moved {return}
            selectedUnit.move(to: tappedMove)
            turnController.moved = true
            if turnController.attacked && !turnController.moved {
                turnController.currentTurn = TurnSigns.END
            }
            if !turnController.attacked && turnController.moved {
                turnController.currentTurn = TurnSigns.END
            }
            if turnController.attacked && turnController.moved {
                DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.enemyGetNewTurnDelay, execute: {
                    self.turnController.currentTurn = TurnSigns.ENEMY
                })
            }
            let action = SKAction.move(to: tappedMove.position, duration: TimeController.regularCameraMovement)
            battleScene.cameraNode.run(action)
        } else {
            // before attacking the unit itself, check if the player has attacked
            if turnController.attacked {return}
            // tapped a red square
            battleScene.updateCharacterNode(unit: tappedUnits[0]) // possibly an enemy
            battleScene.floatingPanels.append(selectedUnit.attack(target: tappedUnits[0], cameraXScale: battleScene.cameraNode.xScale)) // for remove later
            storedTarget = tappedUnits[0]
        }
        storedUser = selectedUnit
        selectedItem = nil
    }
    
    private func unitIsNotNull(tappedUnit: Unit) {
        guard let battleScene = battleScene else {return}
        battleScene.battleManager.units.forEach {$0.floatingPanelIsShown = false}
        if battleScene.floatingPanels.count > 0 {
            battleScene.floatingPanels.forEach {$0.removeFromParent()}
        }
        if selectedItem != nil {
            // cast skill to self
            // before attacking the unit itself, check if the player has attacked
            if turnController.attacked {return}
            guard let selectedUnit = selectedItem as? Unit else {return} // your unit
            // if you have a controlled unit, you must only use that unit
            if turnController.controlledUnitBattleIndex != -1 {
                if selectedUnit.battleIndex != turnController.controlledUnitBattleIndex {return}
            }
            // you cannot control a unit that is not yours
            else if !selectedUnit.isAlly || !selectedUnit.isAlive {return}
            guard selectedUnit == tappedUnit else {return} // the second tap is also your unit
            if selectedUnit.isJustBeenMorphedBySelf {
                selectedUnit.clearCDForAllSkills()
                selectedUnit.isJustBeenMorphedBySelf = false
            }
            battleScene.floatingPanels.append(selectedUnit.attack(target: selectedUnit, cameraXScale: battleScene.cameraNode.xScale)) // for remove later
            storedUser = selectedUnit
            storedTarget = selectedUnit
            selectedItem = nil
        } else {
            selectedItem = tappedUnit // store the tapped unit
        }
        prevBuffIcon = nil
    }
    
    private func thereIsButton(buttonName: String) { // Here is where the attack really happens
        // cast skill to some unit other than your selected unit
        guard let battleScene = battleScene else {return}
        var skillIndex = Int(buttonName)
        if storedUser!.skills.count-1 < skillIndex ?? 0 {skillIndex = 0}
        var skill = storedUser!.skills[skillIndex ?? 0]
        if storedUser!.cannotMove {
            skill = repealSet[skillIndex ?? 0]
        }
        if (skill.currentCooldown != 0) {
            return
        }
        if (skill.skillType == .MULT_ALLY && storedTarget!.isAlly != storedUser!.isAlly) ||
            (skill.skillType == .MULT_ENEMY && storedTarget!.isAlly == storedUser!.isAlly) ||
            (skill.skillType == .SOLO_ALLY && storedTarget!.isAlly != storedUser!.isAlly) ||
            (skill.skillType == .SOLO_ENEMY && storedTarget!.isAlly == storedUser!.isAlly) {
            return
        }
        battleScene.battleManager.skillCaster.cast(skill: skill, user: storedUser!, targets: [storedTarget!], mapCreator: battleScene.mapCreator)
        storedUser!.skills[skillIndex ?? 0].currentCooldown = storedUser!.skills[skillIndex ?? 0].originalCooldown
        battleScene.updateHPBar(to: storedTarget!)
        battleScene.floatingPanels.forEach {$0.removeFromParent()}
        
        if turnController.enemyAI.isWinOrLoseDetermined(allUnits: battleScene.battleManager.units, battleScene: battleScene) {return}
        
        turnController.attacked = true
        battleScene.battleManager.units.forEach {$0.characterBase.isHidden = false}
        if turnController.attacked && !turnController.moved {
            turnController.currentTurn = TurnSigns.END
        }
        if !turnController.attacked && turnController.moved {
            turnController.currentTurn = TurnSigns.END
        }
        if turnController.attacked && turnController.moved {
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.enemyGetNewTurnDelay, execute: {
                self.turnController.currentTurn = TurnSigns.ENEMY
            })
        }
    }
    
    private func nothingIsTapped() {
        guard let battleScene = battleScene else {return}
        if let selectedUnit = selectedItem as? Unit {
            selectedUnit.characterBase.isHidden = false
        }
        
        battleScene.battleManager.units.forEach {$0.floatingPanelIsShown = false}
        battleScene.floatingPanels.forEach {$0.removeFromParent()}
        cameraResetCounter += 1
        if cameraResetCounter == 3 {
            let action = SKAction.move(to: CGPoint(x: battleScene.mapCreator.getCol()*battleScene.mapCreator.getEdgeLength()/2, y: battleScene.mapCreator.getRow()*battleScene.mapCreator.getEdgeLength()/2), duration: TimeController.regularCameraMovement)
            battleScene.cameraNode.run(action)
            cameraResetCounter = 0
        }
        selectedItem = nil
    }
    
    func selectedItemChanged() {
        mover.hideMoveOptions()
        if turnController.moved && turnController.attacked {
            mover.hideSelectinMarker()
            return
        }
        if let _ = selectedItem {
            mover.showSelectionMarker()
            if selectedItem is Unit {
                guard let unit = selectedItem as? Unit else {return}
                battleScene?.updateCharacterNode(unit: unit)
                mover.showMoveOptions()
            }
        } else {
            mover.hideSelectinMarker()
        }
    }
}
