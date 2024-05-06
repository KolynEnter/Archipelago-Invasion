//
//  LevelCalculator.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/14/23.
//

import Foundation

class XPCalculator {
    private let levels: Int = 80
    private let start: Int = 1000
    private var A: Double
    private var B: Double
    
    init() {
        B = 2.2
        A = Double(start) / (exp(B) - 1.0)
    }
    
    func showXPTable() {
        for i in 1 ..< levels {
            print("\(i): \(xpForLevel(i))")
        }
    }
    
    func xpForLevel(_ i: Int) -> Int {
        let x = round(A * exp(B * 0.066*Double((i-1))))
        let y = round(A * exp(B * 0.066*Double((i)))) + Double(50 * i)
        return Int(y-x)
    }
}
