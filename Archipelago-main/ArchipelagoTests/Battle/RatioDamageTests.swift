//
//  SkillTests.swift
//  ArchipelagoTests
//
//  Created by Jianxin Lin on 3/11/23.
//

import XCTest
@testable import Archipelago

final class RatioDamageTests: XCTestCase {
    
    var battleScene: BattleScene?
    var dummy0: Dummy?
    var dummy1: Dummy?
    var dummy2: Dummy?
    var dummyField: DummyField?
    
    override func setUpWithError() throws {
        battleScene = BattleScene()
        dummy0 = Dummy(isAlly: true)
        dummy1 = Dummy(isAlly: false)
        dummy2 = Dummy(isAlly: false)
        dummyField = DummyField(dummys: [dummy0!, dummy1!, dummy2!], battleScene: battleScene!)
    }
    
    override func tearDownWithError() throws {
        battleScene = nil
        dummy0 = nil
        dummy1 = nil
        dummy2 = nil
        dummyField = nil
    }
    
    func testAttackRatioDamageSingleTarget() {
        // strike: 100% * atk
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        dummyField?.ignoreRoundingErrorTesting(value: dummy1!.hpCurrent, expected: 50)
        dummyField?.ignoreRoundingErrorTesting(value: dummy1!.hpMax, expected: 100)
    }
    
    func testAttackRatioDamageMultiTarget() {
        // soul strike: 50% * atk
        dummy0?.skills = [SoulStrike()]
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!, dummy2!], skillIndex: 0), 1)
        dummyField?.ignoreRoundingErrorTesting(value: dummy1!.hpCurrent, expected: 75)
        dummyField?.ignoreRoundingErrorTesting(value: dummy1!.hpMax, expected: 100)
        dummyField?.ignoreRoundingErrorTesting(value: dummy2!.hpCurrent, expected: 75)
        dummyField?.ignoreRoundingErrorTesting(value: dummy2!.hpMax, expected: 100)
    }
    
    func testIfCurrentHpBelowZeroSingleTarget() {
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 3)
        dummyField?.ignoreRoundingErrorTesting(value: dummy1!.hpCurrent, expected: 0)
        dummyField?.ignoreRoundingErrorTesting(value: dummy1!.hpMax, expected: 100)
    }
    
    func testIfCurrentHpBelowZeroMultiTarget() {
        dummy0?.skills = [SoulStrike()]
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!, dummy2!], skillIndex: 0), 5)
        dummyField?.ignoreRoundingErrorTesting(value: dummy1!.hpCurrent, expected: 0)
        dummyField?.ignoreRoundingErrorTesting(value: dummy1!.hpMax, expected: 100)
        dummyField?.ignoreRoundingErrorTesting(value: dummy2!.hpCurrent, expected: 0)
        dummyField?.ignoreRoundingErrorTesting(value: dummy2!.hpMax, expected: 100)
    }
}
