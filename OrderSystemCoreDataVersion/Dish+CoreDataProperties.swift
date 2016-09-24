//
//  Dish+CoreDataProperties.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 24/9/16.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import Foundation
import CoreData

extension Dish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dish> {
        return NSFetchRequest<Dish>(entityName: "Dish");
    }

    @NSManaged public var alias: String?
    @NSManaged public var detail: String?
    @NSManaged public var detailTrans: String?
    @NSManaged public var image: NSObject?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var sequenceId: Int16
    @NSManaged public var toDishCategory: DishCategory?
    @NSManaged public var toSubCategory: NSSet?

}

// MARK: Generated accessors for toSubCategory
extension Dish {

    @objc(addToSubCategoryObject:)
    @NSManaged public func addToToSubCategory(_ value: SubCategory)

    @objc(removeToSubCategoryObject:)
    @NSManaged public func removeFromToSubCategory(_ value: SubCategory)

    @objc(addToSubCategory:)
    @NSManaged public func addToToSubCategory(_ values: NSSet)

    @objc(removeToSubCategory:)
    @NSManaged public func removeFromToSubCategory(_ values: NSSet)

}
