//
//  EnemyBaseDataReader.swift
//  Archipelago
//
//  Created by Jianxin Lin on 1/29/23.
//

import Foundation

class UnitBaseDataLoader {
    var unitBaseData = [UnitBaseData]()
    
    init() {
        load(file: "Enemy base data-1")
    }
    
    func load(file: String) {
        if let fileLocation = Bundle.main.url(forResource: file, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJSON = try jsonDecoder.decode([UnitBaseData].self, from: data)
                unitBaseData = dataFromJSON
            } catch {
                print(error)
            }
        }
    }
}
