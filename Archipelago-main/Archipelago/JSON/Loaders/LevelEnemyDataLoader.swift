//
//  LevelEnemyDataLoader.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/30/23.
//

import Foundation

class LevelEnemyDataLoader {
    var levelEnemyDatas: [LevelEnemyData]!
    
    init(fileName: String) {
        load(file: fileName)
    }
    
    func load(file: String) {
        if let fileLocation = Bundle.main.url(forResource: file, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJSON = try jsonDecoder.decode([LevelEnemyData].self, from: data)
                levelEnemyDatas = dataFromJSON
            } catch {
                print(error)
            }
        }
    }
}
