//
//  InventoryItem+CoreDataProperties.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/4/23.
//
//

import Foundation
import CoreData


extension InventoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InventoryItem> {
        return NSFetchRequest<InventoryItem>(entityName: "InventoryItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: Int32

}

extension InventoryItem : Identifiable {

}
