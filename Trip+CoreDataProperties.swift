//
//  Trip+CoreDataProperties.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var inbound: Date?
    @NSManaged public var outbound: Date?
    @NSManaged public var accomAddress: String?
    @NSManaged public var accomName: String?
    @NSManaged public var destination: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double

}

extension Trip : Identifiable {

}
