//
//  BattleMapCreator.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/28/23.
//

import SpriteKit

class BattleMapCreator: FileBasedMapCreator {
    var battleMap: SKNode!
    
    override init() {
        super.init()
    }
    
    func generateFileBasedMap() {
        battleMap = fileBasedMap(mapName: "map1", rotatedReverseNinty: false)
    }
}
