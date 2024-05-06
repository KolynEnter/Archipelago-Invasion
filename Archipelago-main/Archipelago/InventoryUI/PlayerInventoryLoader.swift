//
//  PlayerInventoryLoader.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/4/23.
//

import UIKit
import CoreData

class PlayerInventoryLoader {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models: [InventoryItem]!
    
    init() {
        getAllItems()
    }
    
    // Core Data
    func getAllItems() {
        do {
            models = try context.fetch(InventoryItem.fetchRequest())
            
            // always want cash and soul being displayed at the top
            let cashIndex = getItemIndex(itemName: "Cash")
            let soulIndex = getItemIndex(itemName: "Soul")
            guard cashIndex != -1 else {return}
            guard soulIndex != -1 else {return}
            models.swapAt(cashIndex, 0)
            models.swapAt(soulIndex, 1)
            
            // sorting by alphabet
            let isFixed: (String)->Bool = {["Cash", "Soul"].contains($0)}
            zip(models.enumerated().filter{!isFixed($1.name!)}, models.filter{!isFixed($0.name!)}.sorted{$0.name! < $1.name!}).forEach{models[$0.0] = $1}
        } catch {
            // error
        }
    }
    
    func createItem(name: String, number: Int32) {
        let newItem = InventoryItem(context: context)
        newItem.name = name
        newItem.number = number
        
        // save change into database
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func deleteItem(item: InventoryItem) {
        context.delete(item)
        
        // save change into database
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func updateNumber(item: InventoryItem, newNumber: Int32) {
        item.number = newNumber
        
        // save change into database
        do {
            try context.save()
            getAllItems()
        } catch {
            
        }
    }
    
    func getItemIndex(itemName: String) -> Int {
        for i in 0 ..< models.count {
            if models[i].name == itemName {
                return i
            }
        }
        return -1
    }
    
    func getNumberOfCash() -> Int32 {
        for i in 0 ..< models.count {
            if models[i].name == "Cash" {
                return models[i].number
            }
        }
        return 0
    }
    
    func getNumberOfSoul() -> Int32 {
        for i in 0 ..< models.count {
            if models[i].name == "Soul" {
                return models[i].number
            }
        }
        return 0
    }
    
    func spendCash(_ amount: Int) {
        for i in 0 ..< models.count {
            if models[i].name == "Cash" {
                updateNumber(item: models[i], newNumber: models[i].number - Int32(amount))
            }
        }
    }
    
    func spendSoul(_ amount: Int) {
        for i in 0 ..< models.count {
            if models[i].name == "Soul" {
                updateNumber(item: models[i], newNumber: models[i].number - Int32(amount))
            }
        }
    }
    
    func DeleteAllData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "InventoryItem"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
}
