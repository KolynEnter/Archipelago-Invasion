//
//  TurnController.swift
//  Archipelago
//
//  Created by Jianxin Lin on 9/2/22.
//

import SpriteKit

class TurnController {
    
    private weak var battleScene: BattleScene?
    var enemyAI: EnemyAI!
    var controlledUnitBattleIndex: Int = -1 {
        didSet {
            moved = false
            attacked = false
        }
    }
    
    // 'END' is actually also player's turn
    var currentTurn = TurnSigns.END {
        didSet {
            guard let battleScene = battleScene else {return}
            if currentTurn == TurnSigns.PLAYER {
                battleScene.battleManager.buffManager.activateAfterTurnBuffs(isAlly: false)
                battleScene.battleManager.buffManager.activateBeforeTurnBuffs(isAlly: true)
                battleScene.viewController?.turnSignButton.setImage(UIImage(named: "TurnSignPlayer"), for: .normal)
                battleScene.describeLabel.text = "Player"
                moved = false
                attacked = false
                battleScene.battleManager.units.forEach {
                    for i in 0 ..< $0.skills.count {
                        $0.skills[i].currentCooldown -= 1
                        if $0.skills[i].currentCooldown < 0 {
                            $0.skills[i].currentCooldown = 0
                        }
                    }
                }
            } else if currentTurn == TurnSigns.ENEMY {
                battleScene.battleManager.buffManager.activateAfterTurnBuffs(isAlly: true)
                battleScene.battleManager.buffManager.activateBeforeTurnBuffs(isAlly: false)
                battleScene.viewController?.turnSignButton.setImage(UIImage(named: "TurnSignEnemy"), for: .normal)
                battleScene.describeLabel.text = "Enemy"
                enemyAI.enemyTurnStarts(battleScene: battleScene)
                controlledUnitBattleIndex = -1
            } else if currentTurn == TurnSigns.END {
                battleScene.viewController?.turnSignButton.setImage(UIImage(named: "TurnSignEnd"), for: .normal)
                battleScene.describeLabel.text = "End"
            }
        }
    }
    
    var moved: Bool = false
    var attacked: Bool = false
    
    init(battleScene: BattleScene) {
        self.battleScene = battleScene
        enemyAI = EnemyAI(mapCreator: battleScene.mapCreator)
    }
}
