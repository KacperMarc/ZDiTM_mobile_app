//
//  Stops+CoreDataProperties.swift
//  zditmapp
//
//  Created by Kacper Marciszewski on 28/02/2025.
//
//

import Foundation
import CoreData


extension Stops {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stops> {
        return NSFetchRequest<Stops>(entityName: "Stops")
    }
    
    @nonobjc public class func fetchRequestForNames() -> NSFetchRequest<Stops> {
        let request = NSFetchRequest<Stops>(entityName: "Stops")
        request.propertiesToFetch = ["name"]
        request.resultType = .dictionaryResultType
        return request
    }

    @NSManaged public var request_stop: Bool
    @NSManaged public var longitude: Float
    @NSManaged public var latitude: Float
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var id: Int32
    
    
}

extension Stops : Identifiable {

}
