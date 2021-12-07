//
//  Trip+CoreDataProperties.swift
//  TravelWell
//
//  Created by Callum Graham on 18/11/2021.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var accomAddress: String?
    @NSManaged public var accomName: String?
    @NSManaged public var destination: String?
    @NSManaged public var inbound: Date?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var outbound: Date?
    @NSManaged public var timeZone: String?
    @NSManaged public var favourite: NSSet?
    @NSManaged public var expense: NSSet?

}

// MARK: Generated accessors for favourite
extension Trip {

    @objc(addFavouriteObject:)
    @NSManaged public func addToFavourite(_ value: Favourite)

    @objc(removeFavouriteObject:)
    @NSManaged public func removeFromFavourite(_ value: Favourite)

    @objc(addFavourite:)
    @NSManaged public func addToFavourite(_ values: NSSet)

    @objc(removeFavourite:)
    @NSManaged public func removeFromFavourite(_ values: NSSet)

}

extension Trip : Identifiable {

}
