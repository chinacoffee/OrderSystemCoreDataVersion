//
//  DishCategory+CoreDataProperties.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 23/9/16.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import Foundation
import CoreData

extension DishCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DishCategory> {
        return NSFetchRequest<DishCategory>(entityName: "DishCategory");
    }

    @NSManaged public var alias: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var title: String?
    @NSManaged public var sequenceId: Int16
    @NSManaged public var toDish: NSSet?

}

// MARK: Generated accessors for toDish
extension DishCategory {

    @objc(addToDishObject:)
    @NSManaged public func addToToDish(_ value: Dish)

    @objc(removeToDishObject:)
    @NSManaged public func removeFromToDish(_ value: Dish)

    @objc(addToDish:)
    @NSManaged public func addToToDish(_ values: NSSet)

    @objc(removeToDish:)
    @NSManaged public func removeFromToDish(_ values: NSSet)

}
