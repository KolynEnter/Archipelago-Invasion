//
//  SpecificationRequestor.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/27/22.
//

import SpriteKit

// DO NOT USE, ONLY FOR TESTING PURPOSE

class SpecificationRequestor {
    // Enter "require additional selection" mode
    // 1. you have a skill that has requireSpecification property to be true
    // 2. you need to be able to select targets and store them somewhere
    //    - you also need to filter the selectable units
    // 3. you need to be able to send the result to activation, which is in tapper
     
    var storedTargets: [Unit] = []
    
    // A skill that requires speficition is tapped, enter this mode
    // tap a unit in range to select, tap it again to undo selection
    func enterSpecificationMode(skill: Skill, user: Unit, battleScene: BattleScene) {
        /*
        let unitInRangeGetter: UnitInRangeGetter = UnitInRangeGetter(mapCreator: battleScene.mapCreator, predefinedAttackerPos: user.position)
        var selectableUnits: [Unit]
        if skill.range == .LOCAL {
            selectableUnits = unitInRangeGetter.getAllUnitsWithinRange(user: user, allUnits: battleScene.units)
        } else {
            selectableUnits = battleScene.units.filter {$0.battleIndex != user.battleIndex}
        }
        // Paint selectable units with yellow
        var points: [CGPoint] = []
        selectableUnits.forEach {
            points.append($0.position)
        }

        paintSquareBasedOnGivenPositions(mover: battleScene.mover, points: points, color: UIColor.yellow)
         */
    }
    
    func paintSquareBasedOnGivenPositions(mover: Mover, points: [CGPoint], color: UIColor) {
        /*
        var paintedPosition: [CGPoint] = []
        for point in points {
            if !mover.squarePositionIsInBoard(squarePosition: point) {
                return
            }
            mover.moveSquares.forEach {
                if $0.position == point {
                    if !paintedPosition.contains(point) {
                        $0.color = color
                        $0.alpha = 0.4
                        paintedPosition.append(point)
                    }
                }
            }
        }
         */
    }
}
