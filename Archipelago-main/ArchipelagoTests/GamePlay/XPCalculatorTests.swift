//
//  XPCalculatorTests.swift
//  ArchipelagoTests
//
//  Created by Jianxin Lin on 3/11/23.
//

import XCTest
@testable import Archipelago

final class XPCalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testXPRequiredAreInscend() {
        let calculator = XPCalculator()
        var prev = 0
        for i in 1 ..< 101 {
            let xp = calculator.xpForLevel(i)
            XCTAssertLessThan(prev, xp, "previous level xp required should not be greater")
            prev = xp
        }
    }
    
    func testPerformance() {
        measure {
            _ = XPCalculator()
        }
    }
}
