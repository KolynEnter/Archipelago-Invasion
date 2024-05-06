//
//  UnitsLoader.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/5/23.
//

import UIKit
import CoreData

class AllyUnitsLoader {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models: [AllyUnit]!
    
    init() {
        getAllUnits()
    }
    
    // Core Data
    func getAllUnits() {
        do {
            models = try context.fetch(AllyUnit.fetchRequest())
        } catch {
            // error
        }
    }
    
    func createUnit(unit: Unit) {
        let newUnit = AllyUnit(context: context)
        newUnit.uniqueID = unit.uniqueID
        newUnit.imageName = unit.getImageName()
        newUnit.name = unit.name
        newUnit.atk = unit.atk
        newUnit.hpMax = unit.hpMax
        newUnit.currentExp = 0
        newUnit.level = 1
        guard unit.skills.count > 0 else {
            newUnit.skill0 = "nil"
            newUnit.skill1 = "nil"
            newUnit.skill2 = "nil"
            newUnit.skill3 = "nil"
            // save change into database
            do {
                try context.save()
                getAllUnits()
            } catch {
                
            }
            return
        }
        newUnit.skill0 = skillToString(skill: unit.skills[0])
        guard unit.skills.count > 1 else {
            newUnit.skill1 = "nil"
            newUnit.skill2 = "nil"
            newUnit.skill3 = "nil"
            // save change into database
            do {
                try context.save()
                getAllUnits()
            } catch {
                
            }
            return
        }
        newUnit.skill1 = skillToString(skill: unit.skills[1])
        guard unit.skills.count > 2 else {
            newUnit.skill2 = "nil"
            newUnit.skill3 = "nil"
            // save change into database
            do {
                try context.save()
                getAllUnits()
            } catch {
                
            }
            return
        }
        newUnit.skill2 = skillToString(skill: unit.skills[2])
        guard unit.skills.count > 3 else {
            newUnit.skill3 = "nil"
            // save change into database
            do {
                try context.save()
                getAllUnits()
            } catch {
                
            }
            return
        }
        newUnit.skill3 = skillToString(skill: unit.skills[3])
        
        // save change into database
        do {
            try context.save()
            getAllUnits()
        } catch {
            
        }
    }
    
    func deleteUnit(unit: AllyUnit) {
        context.delete(unit)
        
        // save change into database
        do {
            try context.save()
            getAllUnits()
        } catch {
            
        }
    }
    
    func useSoulOnLevelUp(uniqueID: String, totalSoul: Int) -> Int {
        let allyUnit = models[getUnitIndexInModels(uniqueID: uniqueID)]
        let neededExp = XPCalculator().xpForLevel(Int(allyUnit.level))
        if totalSoul >= neededExp {
            allyUnit.level += 1
            return neededExp
        }
        
        // save change into database
        do {
            try context.save()
            getAllUnits()
        } catch {
            
        }
        return 0
    }
    
    func changeSkillSet(uniqueID: String, newSkillSet: [Skill]) {
        let allyUnit = models[getUnitIndexInModels(uniqueID: uniqueID)]
        guard newSkillSet.count > 0 else {
            allyUnit.skill0 = "nil"
            allyUnit.skill1 = "nil"
            allyUnit.skill2 = "nil"
            allyUnit.skill3 = "nil"
            // save change into database
            do {
                try context.save()
                getAllUnits()
            } catch {
                
            }
            return
        }
        allyUnit.skill0 = skillToString(skill: newSkillSet[0])
        guard newSkillSet.count > 1 else {
            allyUnit.skill1 = "nil"
            allyUnit.skill2 = "nil"
            allyUnit.skill3 = "nil"
            // save change into database
            do {
                try context.save()
                getAllUnits()
            } catch {
                
            }
            return
        }
        allyUnit.skill1 = skillToString(skill: newSkillSet[1])
        guard newSkillSet.count > 2 else {
            allyUnit.skill2 = "nil"
            allyUnit.skill3 = "nil"
            // save change into database
            do {
                try context.save()
                getAllUnits()
            } catch {
                
            }
            return
        }
        allyUnit.skill2 = skillToString(skill: newSkillSet[2])
        guard newSkillSet.count > 3 else {
            allyUnit.skill3 = "nil"
            // save change into database
            do {
                try context.save()
                getAllUnits()
            } catch {
                
            }
            return
        }
        allyUnit.skill3 = skillToString(skill: newSkillSet[3])
        
        // save change into database
        do {
            try context.save()
            getAllUnits()
        } catch {
            
        }
    }
    
    func getUnitIndexInModels(uniqueID: String) -> Int {
        for i in 0 ..< models.count {
            if models[i].uniqueID == uniqueID {
                return i
            }
        }
        return -1
    }
    
    func DeleteAllData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "AllyUnit"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
}
