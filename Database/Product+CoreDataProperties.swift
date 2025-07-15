//
//  Product+CoreDataProperties.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 01/03/2025.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var name: String?

}

extension Product : Identifiable {

}
