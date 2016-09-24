//
//  SubCategory+CoreDataProperties.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 20/09/2016.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import Foundation
import CoreData
 

extension SubCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubCategory> {
        return NSFetchRequest<SubCategory>(entityName: "SubCategory");
    }

    @NSManaged public var isMandatory: Bool
    @NSManaged public var isSingleSelected: Bool
    @NSManaged public var toDish: Dish?
    @NSManaged public var toIngredient: NSSet?

}

// MARK: Generated accessors for toIngredient
extension SubCategory {

    @objc(addToIngredientObject:)
    @NSManaged public func addToToIngredient(_ value: Ingredient)

    @objc(removeToIngredientObject:)
    @NSManaged public func removeFromToIngredient(_ value: Ingredient)

    @objc(addToIngredient:)
    @NSManaged public func addToToIngredient(_ values: NSSet)

    @objc(removeToIngredient:)
    @NSManaged public func removeFromToIngredient(_ values: NSSet)

}
