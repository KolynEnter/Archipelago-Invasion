//
//  BuffTests.swift
//  ArchipelagoTests
//
//  Created by Jianxin Lin on 3/12/23.
//

import XCTest
@testable import Archipelago

final class BuffTests: XCTestCase {

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
    
    func addBuff(buffID: BuffID, toDummy dummyA: Dummy, byDummy dummyB: Dummy) {
        battleScene?.battleManager.buffManager.addBuffToUnit(buff: idToBuff(id: buffID, carryUnit: dummyA, applierUnit: dummyB), unit: dummyA)
    }
    
    func dummyShouldHaveBuffs(ofNumber number: Int, dummy: Dummy, message: String? = nil) {
        XCTAssertEqual(battleScene?.battleManager.buffManager.unitBuffs[dummy.battleIndex].buffs.count, number)
        if let message = message {
            print(message)
        }
    }
    
    func getBuff(OfDummy dummy: Dummy, inIndex index: Int) -> BuffObject? {
        return battleScene?.battleManager.buffManager.unitBuffs[dummy.battleIndex].buffs[index]
    }
    
    func expectedHp(type: String, toBe number: Float, forDummy dummy: Dummy) {
        type == "current" ?
        dummyField?.ignoreRoundingErrorTesting(value: dummy.hpCurrent, expected: number) :
        dummyField?.ignoreRoundingErrorTesting(value: dummy.hpMax, expected: number)
    }
    
    func expectedToBeInFullHp(dummy: Dummy) {
        expectedHp(type: "current", toBe: dummy.hpMax, forDummy: dummy)
    }
    
    func testPolishing() {
        // next attack damage * 2
        // before attack
        dummyField?.repeater(addBuff(buffID: BuffID.Polishing, toDummy: dummy0!, byDummy: dummy0!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Polishing, "dummy0 should have polishing in index 0")
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        expectedHp(type: "current", toBe: 0, forDummy: dummy1!)
        expectedHp(type: "maximum", toBe: 100, forDummy: dummy1!)
        battleScene?.setCurrentTurn(to: TurnSigns.END)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy1!, inIndex: 0) is Dead, "dummy1 should be dead")
    }
    
    func testPolishingStack() {
        // polish cannot be stacked
        dummyField?.repeater(addBuff(buffID: BuffID.Polishing, toDummy: dummy0!, byDummy: dummy0!), 2)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Polishing, "dummy0 should have polishing in index 0")
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        expectedHp(type: "current", toBe: 0, forDummy: dummy1!)
        expectedHp(type: "maximum", toBe: 100, forDummy: dummy1!)
        battleScene?.setCurrentTurn(to: TurnSigns.END)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy1!, inIndex: 0) is Dead, "dummy1 should be dead")
    }
    
    // test the buff has a limited duration
    func testPoisoned() {
        // poisoned lasts one turn and is triggered after turn
        // poisoned reduces carrier's 10% current HP
        dummyField?.repeater(addBuff(buffID: BuffID.Poisoned, toDummy: dummy0!, byDummy: dummy1!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Poisoned, "dummy0 should be poisoned in index 0")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.END)
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.ENEMY)
        expectedHp(type: "current", toBe: 90, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy0!, message: "Poisoned should be removed")
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
    }
    
    func testBlind() {
        // blind makes the carrier's next attack invalid
        dummyField?.repeater(addBuff(buffID: BuffID.Blind, toDummy: dummy0!, byDummy: dummy1!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Blind, "dummy0 should be blind in index 0")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
    }
    
    func testSwordDefense() {
        /*
        Before receive damage, ignore this damage and return
        carrier's raw attack - attacker's raw attack damage to
        the attacker
         */
        dummyField?.repeater(addBuff(buffID: BuffID.SwordDefense, toDummy: dummy0!, byDummy: dummy0!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is SwordDefense, "dummy0 should be sword-defensing in index 0")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy1!, dummys: [dummy0!], skillIndex: 0), 1)
        expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
    }
    
    
    
    // test if buff can coexist with other buffs
    func testBuffCoexistance() {
        dummyField?.repeater(addBuff(buffID: BuffID.Bleeding, toDummy: dummy0!, byDummy: dummy1!), 1)
        dummyField?.repeater(addBuff(buffID: BuffID.Poisoned, toDummy: dummy0!, byDummy: dummy1!), 1)
        dummyShouldHaveBuffs(ofNumber: 2, dummy: dummy0!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Bleeding, "dummy0 should be bleeding in index 0")
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 1) is Poisoned, "dummy0 should be poisoned in index 1")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.END)
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.ENEMY)
        expectedHp(type: "current", toBe: 85.5, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!, message: "Poisoned should be removed")
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Bleeding, "dummy0 should be bleeding in index 0")
    }
    
    // make sure stackable buffs stack
    func testIrradiated() {
        // irradiated lasts two turns and is triggered before turn
        // irradiated can be stacked
        // irradiated reduces carrier's 5% current HP
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.END)
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.ENEMY)
        dummyField?.repeater(addBuff(buffID: BuffID.Irradiated, toDummy: dummy0!, byDummy: dummy1!), 2)
        dummyShouldHaveBuffs(ofNumber: 2, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Irradiated, "dummy0 is irradiated in index 0")
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 1) is Irradiated, "dummy0 is irradiated in index 1")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.PLAYER)
        expectedHp(type: "current", toBe: 90.25, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
    }
    
    // make sure refreshable buff refresh
    func testBleeding() {
        // bleeding lasts two turns and is triggered after turn
        // bleeding can be refreshed
        // bleeding reduces carrier's 5% current HP
        dummyField?.repeater(addBuff(buffID: BuffID.Bleeding, toDummy: dummy0!, byDummy: dummy1!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Bleeding, "dummy0 should be bleeding in index 0")
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0)?.sustainability == 2, "bleeding should have sustainability of 2")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.END)
        dummyField?.battleScene?.setCurrentTurn(to: TurnSigns.ENEMY)
        expectedHp(type: "current", toBe: 95, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 100, forDummy: dummy1!)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!, message: "Bleeding should retain")
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0)?.sustainability == 1, "bleeding should have sustainability of 1")
        dummyField?.repeater(addBuff(buffID: BuffID.Bleeding, toDummy: dummy0!, byDummy: dummy1!), 1)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0)?.sustainability == 2, "bleeding should have sustainability of 2")
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!, message: "No new buff should be added")
    }
    
    // make sure non-refreshable buff don't refresh
    func testAttackUp() {
        // attack up lasts two turns and is triggered before attack
        // attack up makes next damage * 1.2
        dummyField?.repeater(addBuff(buffID: BuffID.AttackUp, toDummy: dummy0!, byDummy: dummy0!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is AttackUp, "dummy0 should be attack-up-ed in index 0")
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0)?.sustainability == 2, "attack-up should have sustainability of 2")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 40, forDummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0)?.sustainability == 1, "attack-up should have sustainability of 1")
        dummyField?.repeater(addBuff(buffID: BuffID.AttackUp, toDummy: dummy0!, byDummy: dummy0!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0)?.sustainability == 1, "attack-up should have sustainability of 1")
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 0, forDummy: dummy1!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy0!)
        XCTAssertTrue(getBuff(OfDummy: dummy1!, inIndex: 0) is Dead, "dummy1 should be dead")
    }
    
    // make sure non-stackable buff don't stack
    func testAttackDown() {
        dummyField?.repeater(addBuff(buffID: BuffID.AttackDown, toDummy: dummy0!, byDummy: dummy0!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is AttackDown, "dummy0 should be attack-down-ed in index 0")
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0)?.sustainability == 2, "attack-up should have sustainability of 2")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        dummyField?.repeater(dummyField?.puppeter(dummy0: dummy0!, dummys: [dummy1!], skillIndex: 0), 1)
        expectedHp(type: "current", toBe: 100, forDummy: dummy0!)
        expectedHp(type: "current", toBe: 60, forDummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0)?.sustainability == 1, "attack-down should have sustainability of 1")
        dummyField?.repeater(addBuff(buffID: BuffID.AttackDown, toDummy: dummy0!, byDummy: dummy0!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
    }
    
    // verify that the buff can be removed manually
    func testRemovingBuff() {
        dummyField?.repeater(addBuff(buffID: BuffID.Poisoned, toDummy: dummy0!, byDummy: dummy1!), 1)
        dummyShouldHaveBuffs(ofNumber: 1, dummy: dummy0!)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy1!)
        XCTAssertTrue(getBuff(OfDummy: dummy0!, inIndex: 0) is Poisoned, "dummy0 should be poisoned in index 0")
        expectedToBeInFullHp(dummy: dummy0!)
        expectedToBeInFullHp(dummy: dummy1!)
        battleScene?.battleManager.buffManager.unitBuffs[0].buffs.remove(at: 0)
        dummyShouldHaveBuffs(ofNumber: 0, dummy: dummy0!)
    }
}
