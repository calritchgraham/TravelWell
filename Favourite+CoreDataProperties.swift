//
//  Favourite+CoreDataProperties.swift
//  TravelWell
//
//  Created by Callum Graham on 10/11/2021.
//
//

import Foundation
import CoreData


extension Favourite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favourite> {
        return NSFetchRequest<Favourite>(entityName: "Favourite")
    }

    @NSManaged public var name: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var trip: Trip?

}

extension Favourite : Identifiable {

}
