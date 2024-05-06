//
//  LevelEnemyData.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/30/23.
//

import Foundation

struct LevelEnemyData: Codable {
    
    var level: [Level]
    
    struct Level: Codable {
        var enemy: [Enemy]
        var loot: [Int]
    }
    
    struct Enemy: Codable {
        let image_name: String
        let magnification: Int
        let number: Int
        let skills: [String]
        let materials: [MaterialDrop]
    }
}
