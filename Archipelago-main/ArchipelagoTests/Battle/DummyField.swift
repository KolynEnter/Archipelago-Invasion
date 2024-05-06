//
//  DummyFieldInitializer.swift
//  ArchipelagoTests
//
//  Created by Jianxin Lin on 3/12/23.
//

import Foundation
import XCTest
@testable import Archipelago

class DummyField {
    
    var battleScene: BattleScene?
    
    init(dummys: [Dummy], battleScene: BattleScene) {
        battleScene.warmScene()
        battleScene.battleManager.units = dummys
        battleScene.battleManager.buffManager.initializeUnitBuffs()
        self.battleScene = battleScene
        var battleIndex = 0
        dummys.forEach {
            $0.skills = [Strike()]
            $0.atk = 50
            $0.hpMax = 100
            $0.hpCurrent = $0.hpMax
            $0.battleIndex = battleIndex
            battleIndex += 1
        }
    }
    
    func puppeter(dummy0: Dummy, dummys: [Dummy], skillIndex: Int) -> () {
        dummy0.skills[skillIndex].activate(user: dummy0, targets: dummys, buffManager: self.battleScene!.battleManager!.buffManager)
    }

    func repeater<T>(_ closure: @autoclosure () -> T, _ number: Int) {
        for _ in 0 ..< number {
            _ = closure()
        }
    }
    
    func ignoreRoundingErrorTesting(value: Float, expected: Float) {
        XCTAssertLessThan(value, expected+1)
        XCTAssertGreaterThan(value, expected-1)
    }
    
    func expectedHp(type: String, toBe number: Float, forDummy dummy: Dummy) {
        type == "current" ?
        ignoreRoundingErrorTesting(value: dummy.hpCurrent, expected: number) :
        ignoreRoundingErrorTesting(value: dummy.hpMax, expected: number)
    }
    
    func expectedToBeInFullHp(dummy: Dummy) {
        expectedHp(type: "current", toBe: dummy.hpMax, forDummy: dummy)
    }

}
