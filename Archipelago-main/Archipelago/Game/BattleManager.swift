//
//  BattleManager.swift
//  Archipelago
//
//  Created by Jianxin Lin on 12/24/22.
//

// Battle manager manages the units in the battlefield
// Input:
//  Player units
//  Monster units info
// Player and monster units are stored in two lists
// Then it assigns a battle index to each unit according to the lists

import SpriteKit

class BattleManager {
    
    private weak var battleScene: BattleScene?
    var buffManager: BuffManager
    var skillCaster: SkillCaster!
    var units = [Unit]()
    var originalSkillSetForUnits = [[Skill]]()
    private var unitBaseDataLoader: UnitBaseDataLoader!
    private var additionalMaterials = [MaterialDrop]()
    private var playerInventoryLoader = PlayerInventoryLoader()
    
    struct MaterialAndNumber {
        let name: String
        var number: Int
    }
    
    init(battleScene: BattleScene) {
        self.battleScene = battleScene
        buffManager = BuffManager(battleScene: battleScene)
        skillCaster = SkillCaster(battleManager: self)
        unitBaseDataLoader = UnitBaseDataLoader()
    }
    
    func loadWinningMaterials() -> [MaterialAndNumber] {
        var result = [MaterialAndNumber]()
        for unit in units {
            if !unit.isAlly {
                let enemyBaseData = getBaseDataByImageName(imageName: unit.getImageName())
                guard let materials = enemyBaseData?.materials else {continue}
                for material in materials {
                    var numberOfThisMaterial = 0
                    for chance in material.chances { // chance is a string "2: 11"
                        let number = Int(chance.split(separator: ":")[0]) ?? 0
                        let probability = Int(chance.split(separator: ":")[1]) ?? 0
                        if Int.random(in: 0 ..< 100) < probability {
                            numberOfThisMaterial += number
                        }
                    }
                    let materialIndex = findThisMaterial(materialName: material.name, array: result)
                    if materialIndex != -1 {
                        result[materialIndex].number = result[materialIndex].number + numberOfThisMaterial
                    } else {
                        result.append(MaterialAndNumber(name: material.name, number: numberOfThisMaterial))
                    }
                }
            }
        }

        for material in additionalMaterials {
            var numberOfThisMaterial = 0
            for chance in material.chances { // chance is a string "2: 11"
            let number = Int(chance.split(separator: ":")[0]) ?? 0
            let probability = Int(chance.split(separator: ":")[1]) ?? 0
                if Int.random(in: 0 ..< 100) < probability {
                    numberOfThisMaterial += number
                }
            }
            let materialIndex = findThisMaterial(materialName: material.name, array: result)
            if materialIndex != -1 {
                result[materialIndex].number = result[materialIndex].number + numberOfThisMaterial
            } else {
                result.append(MaterialAndNumber(name: material.name, number: numberOfThisMaterial))
            }
        }
        
        // save the items into Core Data
        for i in 0 ..< result.count {
            if result[i].number != 0 {
                let itemIndexInPlayerInventory = playerInventoryLoader.getItemIndex(itemName: result[i].name)
                if itemIndexInPlayerInventory != -1 {
                    playerInventoryLoader.updateNumber(item: playerInventoryLoader.models[itemIndexInPlayerInventory],
                                                       newNumber: playerInventoryLoader.models[itemIndexInPlayerInventory].number + Int32(result[i].number))
                } else {
                    playerInventoryLoader.createItem(name: result[i].name, number: Int32(result[i].number))
                }
            }
        }
        
        return result
    }
    
    private func findThisMaterial (materialName: String, array: [MaterialAndNumber]) -> Int {
        for i in 0 ..< array.count {
            if array[i].name == materialName {
                return i
            }
        }
        return -1
    }
    
    func getBaseDataByImageName(imageName: String) -> UnitBaseData? {
        for unitBaseData in unitBaseDataLoader.unitBaseData {
            if unitBaseData.image_name == imageName {
                return unitBaseData
            }
        }
        return nil
    }
    
    func generatePlayerUnit(position: CGPoint, allyUnit: AllyUnit) {
        guard let battleScene = battleScene else {return}
        
        let unit: Unit = stringToUnit(imageName: allyUnit.imageName ?? "")
        unit.position = position
        unit.isAlly = true
        units.append(unit)
        unit.battleIndex = units.count-1
        battleScene.addChild(unit)
        
        unit.name = allyUnit.name
        unit.hpMax = adjustedStatBasedOnLevel(level: Int(allyUnit.level), baseStat: allyUnit.hpMax)
        unit.hpCurrent = unit.hpMax
        unit.atk = adjustedStatBasedOnLevel(level: Int(allyUnit.level), baseStat: allyUnit.atk)
        unit.skills = []
        if allyUnit.skill0 != "nil" {
            unit.skills.append(stringToSkill(name: allyUnit.skill0 ?? "nil"))
        }
        if allyUnit.skill1 != "nil" {
            unit.skills.append(stringToSkill(name: allyUnit.skill1 ?? "nil"))
        }
        if allyUnit.skill2 != "nil" {
            unit.skills.append(stringToSkill(name: allyUnit.skill2 ?? "nil"))
        }
        if allyUnit.skill3 != "nil" {
            unit.skills.append(stringToSkill(name: allyUnit.skill3 ?? "nil"))
        }
        originalSkillSetForUnits.append(unit.skills)
    }
    
    func generatePlayerUnit(position: CGPoint, id: UnitID, skills: [String]) {
        guard let battleScene = battleScene else {return}
        
        let unit: Unit = IDtoUnit(id: id)
        unit.position = position
        unit.isAlly = true
        units.append(unit)
        unit.battleIndex = units.count-1
        battleScene.addChild(unit)
        
        guard let unitBaseData = getBaseDataByImageName(imageName: unit.getImageName()) else {return}
        let baseATK: Float = Float(100 * unitBaseData.base_atk)/100
        let baseHP: Float = Float(100 * unitBaseData.base_hp)/100
        unit.name = unitBaseData.name
        unit.hpMax = baseHP
        unit.hpCurrent = baseHP
        unit.atk = baseATK
        unit.skills = []
        for skillName in unitBaseData.skills {
            unit.skills.append(stringToSkill(name: skillName))
        }
        for skillName in skills {
            unit.skills.append(stringToSkill(name: skillName))
        }
        originalSkillSetForUnits.append(unit.skills)
    }
    
    func generateEnemy(enemyPosition: CGPoint, enemyID: Int, magnification: Int, additionalMaterials: [MaterialDrop], skills: [String]) {
        guard let battleScene = battleScene else {return}
        
        let enemy: Unit = IDtoUnit(id: UnitID.allCases[enemyID])
        enemy.position = enemyPosition
        units.append(enemy)
        battleScene.addChild(enemy)
        enemy.battleIndex = units.count-1
        
        guard let enemyBaseData = getBaseDataByImageName(imageName: enemy.getImageName()) else {return}
        let baseATK: Float = Float(magnification * enemyBaseData.base_atk)/100
        let baseHP: Float = Float(magnification * enemyBaseData.base_hp)/100
        enemy.name = enemyBaseData.name
        enemy.hpMax = baseHP
        enemy.hpCurrent = baseHP
        enemy.atk = baseATK
        enemy.skills = []
        for skillName in enemyBaseData.skills {
            enemy.skills.append(stringToSkill(name: skillName))
        }
        for skillName in skills {
            enemy.skills.append(stringToSkill(name: skillName))
        }
        for additionalMaterial in additionalMaterials { // save for later consideration
            self.additionalMaterials.append(additionalMaterial)
        }
        originalSkillSetForUnits.append(enemy.skills)
    }
    
    func adjustedStatBasedOnLevel(level: Int, baseStat: Float) -> Float {
        var result: Float = baseStat
        var rate: Float = 1.25
        let stage: Int = level/10
        let remainer: Int = level%10
        var stat = baseStat
        for _ in 0 ..< stage {
            result += Float(rate/100) * Float(stat) * 55
            stat = result
            rate += 0.005
        }
        let sequence: Float = Float(Int(stat) * remainer*(remainer+1)/2)
        result += Float(rate/100 * sequence)
        return result
     }
    
    func initializeBuffManager() {
        buffManager.initializeUnitBuffs()
    }
}
