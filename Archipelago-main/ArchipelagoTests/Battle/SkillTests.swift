//
//  SkillTests.swift
//  ArchipelagoTests
//
//  Created by Jianxin Lin on 3/15/23.
//

import XCTest
@testable import Archipelago

final class SkillTests: XCTestCase {
    
    var battleScene: BattleScene?
    var dummy0: Dummy?
    var dummy1: Dummy?
    var dummyField: DummyField?

    override func setUpWithError() throws {
        battleScene = BattleScene()
        dummy0 = Dummy(isAlly: true)
        dummy1 = Dummy(isAlly: false)
        dummyField = DummyField(dummys: [dummy0!, dummy1!], battleScene: battleScene!)
    }
    
    override func tearDownWithError() throws {
        battleScene = nil
        dummy0 = nil
        dummy1 = nil
        dummyField = nil
    }

    func testRestore() {
        dummy0?.skills = [Strike()]
        dummy1?.skills = [Restore()]
        dummyField?.expectedToBeInFullHp(dummy: dummy0!)
        dummyField?.expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        dummyField?.expectedHp(type: "current", toBe: 50, forDummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy1!, dummys: [dummy1!], skillIndex: 0), 1)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
    }
    
    func testRestoreNotExceedHPMax() {
        dummy0?.skills = [Strike()]
        dummy1?.skills = [Restore()]
        dummyField?.expectedToBeInFullHp(dummy: dummy0!)
        dummyField?.expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        dummyField?.expectedHp(type: "current", toBe: 50, forDummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy1!, dummys: [dummy1!], skillIndex: 0), 1)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy1!, dummys: [dummy1!], skillIndex: 0), 1)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
    }
    
    func testRestoreCanHealEnemy() {
        dummy0?.skills = [Strike()]
        dummy1?.skills = [Restore()]
        dummyField?.expectedToBeInFullHp(dummy: dummy0!)
        dummyField?.expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy0!], skillIndex: 0), 1)
        dummyField?.expectedHp(type: "current", toBe: 50, forDummy: dummy0!)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy1!, dummys: [dummy0!], skillIndex: 0), 1)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy1!, dummys: [dummy0!], skillIndex: 0), 1)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        dummyField?.expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
    }

}
