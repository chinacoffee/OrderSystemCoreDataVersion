//
//  Ingredient+CoreDataProperties.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 20/09/2016.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient");
    }

    @NSManaged public var title: String?
    @NSManaged public var alias: String?
    @NSManaged public var price: Double
    @NSManaged public var image: NSObject?
    @NSManaged public var toSubCategory: SubCategory?

}
