//
//  EnemyAI.swift
//  Archipelago
//
//  Created by Jianxin Lin on 9/3/22.
//

import SpriteKit

class EnemyAI {
    
    // Attack animation is an experimental feature, that's why it is not implemented on player units
    // 1. Find the enemy unit closest to a player unit
    // 2. Find if there is any player unit within its attack range
    //    - if yes, attack the player unit
    //    - if no, move closer to the nearest player unit, check if player unit is in range now
    //      - if yes, attack the player unit

    private let mapCreator: MapCreator!
    private var closestPlayerUnit: Unit!
    private var closestEnemyUnit: Unit!
    
    init(mapCreator: MapCreator) {
        self.mapCreator = mapCreator
    }
    
    func enemyTurnStarts(battleScene: BattleScene) {
        guard let enemy = getClosestEnemyUnitNearPlayerUnit(allUnits: battleScene.battleManager.units) else {return}
        if enemy.cannotMove {
            enemyCannotMove(enemy: enemy, battleScene: battleScene)
            return
        }
        enemyCastSkill(enemy: enemy, battleScene: battleScene)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.regularUnitMoveDelay+0.01, execute: {
            if self.isWinOrLoseDetermined(allUnits: battleScene.battleManager.units, battleScene: battleScene) {return}
        })
         
        flipTheTurnSignToPlayer(battleScene: battleScene)
    }
    
    private func enemyCastSkill(enemy: Unit, battleScene: BattleScene) {
        // Determine the skill going to be used here
        guard let randomSkill: Skill = enemy.skills.randomElement() else {return}
        if !randomSkill.isSelfBuff {
            notSelfBuffSkill(enemy: enemy, battleScene: battleScene, randomSkill: randomSkill)
        } else {
            randomSkill.activate(user: enemy, targets: [enemy], buffManager: battleScene.battleManager.buffManager)
        }
    }
    
    private func enemyCannotMove(enemy: Unit, battleScene: BattleScene) {
        // delay a bit and switch the current turn sign to player
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.regularCameraMovement, execute: {
            // use a repeal
            if enemy.isAlive {
                Repeal().activate(user: enemy, targets: [enemy], buffManager: battleScene.battleManager.buffManager)
                battleScene.battleManager.units.forEach {$0.characterBase.isHidden = false}
            }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.playerGetNewTurnDelay, execute: {
            battleScene.setCurrentTurn(to: TurnSigns.PLAYER)
            battleScene.battleManager.units.forEach {$0.characterBase.isHidden = false}
        })
    }
    
    private func notSelfBuffSkill(enemy: Unit, battleScene: BattleScene, randomSkill: Skill) {
        var playerUnitsInRange = getPlayerUnitInRange(attacker: enemy, allUnits: battleScene.battleManager.units)
        if playerUnitsInRange != [] { // attack and end turn
            /*
             some moves should not have animation since there are self-buff skills
             such as sword defense or polishing
             */
            attackAnimation(attacker: enemy, target: playerUnitsInRange[0])
            if randomSkill.skillType == .SOLO {
                randomSkill.activate(user: enemy, targets: [playerUnitsInRange[0]], buffManager: battleScene.battleManager.buffManager)
            } else if randomSkill.skillType == .MULT_ENEMY && randomSkill.range == .LOCAL {
                randomSkill.activate(user: enemy, targets: playerUnitsInRange, buffManager: battleScene.battleManager.buffManager)
            }
            let cameraMoveToEnemyPosition = SKAction.move(to: enemy.position, duration: TimeController.regularCameraMovement)
            battleScene.cameraNode.run(cameraMoveToEnemyPosition)
        } else {
            moveEnemyUnitCloserToPlayerUnit(battleScene: battleScene) // move closer
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.regularUnitMoveDelay, execute: {
                playerUnitsInRange = self.getPlayerUnitInRange(attacker: self.closestEnemyUnit, allUnits: battleScene.battleManager.units)
                if playerUnitsInRange != [] { // attack and end turn
                    /*
                     some moves should not have animation since there are self-buff skills
                     such as sword defense or polishing
                     */
                    self.attackAnimation(attacker: enemy, target: playerUnitsInRange[0])
                    if randomSkill.skillType == .SOLO {
                        randomSkill.activate(user: enemy, targets: [playerUnitsInRange[0]], buffManager: battleScene.battleManager.buffManager)
                    } else if randomSkill.skillType == .MULT_ENEMY && randomSkill.range == .LOCAL {
                        randomSkill.activate(user: enemy, targets: playerUnitsInRange, buffManager: battleScene.battleManager.buffManager)
                    }
                    let cameraMoveToEnemyPosition = SKAction.move(to: enemy.position, duration: TimeController.regularCameraMovement)
                    battleScene.cameraNode.run(cameraMoveToEnemyPosition)
                }
            })
        }
    }
    
    private func flipTheTurnSignToPlayer(battleScene: BattleScene) {
        // delay a bit and switch the current turn sign to player
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeController.playerGetNewTurnDelay, execute: {
            battleScene.setCurrentTurn(to: TurnSigns.PLAYER)
            battleScene.battleManager.units.forEach {$0.characterBase.isHidden = false}
        })
    }
    
    private func attackAnimation(attacker: Unit, target: Unit) {
        let originalPosition = attacker.position
        let action1 = SKAction.move(to: getAttackAnimationMovingPosition(attackerPosition: originalPosition, targetPosition: target.position), duration: TimeController.enemyUnitStrikes)
        let action2 = SKAction.move(to: originalPosition, duration: TimeController.enemyUnitStrikes/2)
        let sequence = SKAction.sequence([action1, action2])
        attacker.run(sequence)
    }
    
    private func getAttackAnimationMovingPosition(attackerPosition: CGPoint, targetPosition: CGPoint) -> CGPoint {
        var result = CGPoint.zero
        if attackerPosition.x == targetPosition.x && attackerPosition.y < targetPosition.y {
            result = CGPoint(x: attackerPosition.x, y: attackerPosition.y + Double(mapCreator.getEdgeLength()))
        }
        if attackerPosition.x == targetPosition.x && attackerPosition.y > targetPosition.y {
            result = CGPoint(x: attackerPosition.x, y: attackerPosition.y - Double(mapCreator.getEdgeLength()))
        }
        if attackerPosition.x > targetPosition.x && attackerPosition.y == targetPosition.y {
            result = CGPoint(x: attackerPosition.x - Double(mapCreator.getEdgeLength()), y: attackerPosition.y)
        }
        if attackerPosition.x < targetPosition.x && attackerPosition.y == targetPosition.y {
            result = CGPoint(x: attackerPosition.x + Double(mapCreator.getEdgeLength()), y: attackerPosition.y)
        }
        if attackerPosition.x > targetPosition.x && attackerPosition.y < targetPosition.y {
            result = CGPoint(x: attackerPosition.x - Double(mapCreator.getEdgeLength()), y: attackerPosition.y + Double(mapCreator.getEdgeLength()))
        }
        if attackerPosition.x < targetPosition.x && attackerPosition.y > targetPosition.y {
            result = CGPoint(x: attackerPosition.x + Double(mapCreator.getEdgeLength()), y: attackerPosition.y - Double(mapCreator.getEdgeLength()))
        }
        if attackerPosition.x > targetPosition.x && attackerPosition.y > targetPosition.y {
            result = CGPoint(x: attackerPosition.x - Double(mapCreator.getEdgeLength()), y: attackerPosition.y - Double(mapCreator.getEdgeLength()))
        }
        if attackerPosition.x < targetPosition.x && attackerPosition.y < targetPosition.y {
            result = CGPoint(x: attackerPosition.x + Double(mapCreator.getEdgeLength()), y: attackerPosition.y + Double(mapCreator.getEdgeLength()))
        }

        return result
    }
    
    private func getClosestEnemyUnitNearPlayerUnit(allUnits: [Unit]) -> Unit? {
        let playerUnits = allUnits.filter {$0.isAlly && $0.isAlive}
        let enemyUnits = allUnits.filter {!$0.isAlly && $0.isAlive}
        var closestDistance = CGFloat.infinity
        
        for player in playerUnits {
            for enemy in enemyUnits {
                let distance = player.position.manhattanDistance(to: enemy.position)
                if distance < closestDistance {
                    closestDistance = distance
                    closestPlayerUnit = player
                    closestEnemyUnit = enemy
                }
            }
        }
        
        return closestEnemyUnit
    }
    
    private func getPlayerUnitInRange(attacker: Unit, allUnits: [Unit]) -> [Unit] {
        let unitInRangeGetter = UnitInRangeGetter(mapCreator: mapCreator)
        return unitInRangeGetter.getAllHostileUnitsWithinRange(attacker: attacker, allUnits: allUnits).filter {$0.isAlive}
    }
    
    private func moveEnemyUnitCloserToPlayerUnit(battleScene: BattleScene) {
        battleScene.setSelectedItemToNull()
        let autoMoveDeterminator = AutoMoveDeterminator(mapCreator: mapCreator)
        let desiredPosition = autoMoveDeterminator.getDesiredPositionToMove(attacker: closestEnemyUnit, target: closestPlayerUnit)
        closestEnemyUnit.move(to: desiredPosition)
        let action = SKAction.move(to: desiredPosition, duration: TimeController.regularUnitMoveDelay)
        battleScene.cameraNode.run(action)
    }
    
    func isWinOrLoseDetermined(allUnits: [Unit], battleScene: BattleScene) -> Bool {
        if playerLoses(allUnits: allUnits) {
            battleScene.viewController?.goToAccounting(battleResult: .Lose)
            return true
        }
        if monsterLose(allUnits: allUnits) {
            battleScene.viewController?.goToAccounting(battleResult: .Win)
            return true
        }
        return false
    }
    
    private func playerLoses(allUnits: [Unit]) -> Bool {
        var lose = true
        allUnits.forEach {
            if $0.isAlly && $0.isAlive {
                lose = false
            }
        }
        return lose
    }
    
    private func monsterLose(allUnits: [Unit]) -> Bool {
        var lose = true
        allUnits.forEach {
            if !$0.isAlly && $0.isAlive {
                lose = false
            }
        }
        return lose
    }
}
