//
//  AllyUnit+CoreDataProperties.swift
//  Archipelago
//
//  Created by Jianxin Lin on 2/5/23.
//
//

import Foundation
import CoreData


extension AllyUnit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllyUnit> {
        return NSFetchRequest<AllyUnit>(entityName: "AllyUnit")
    }

    @NSManaged public var uniqueID: String?
    @NSManaged public var skill0: String?
    @NSManaged public var skill1: String?
    @NSManaged public var skill2: String?
    @NSManaged public var skill3: String?
    @NSManaged public var hpMax: Float
    @NSManaged public var atk: Float
    @NSManaged public var attribute: Float
    @NSManaged public var imageName: String?
    @NSManaged public var name: String?
    @NSManaged public var level: Int32
    @NSManaged public var currentExp: Int32

}

extension AllyUnit : Identifiable {

}
