//
//  EnemyBaseData.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/29/23.
//

import Foundation

struct UnitBaseData: Codable {

    var name: String
    var image_name: String
    var base_hp: Int
    var base_atk: Int
    var preference: String
    var frame_position: String
    var skills: [String]
    var materials: [MaterialDrop]
}

struct MaterialDrop: Codable {
    var name: String
    var chances: [String]
}
