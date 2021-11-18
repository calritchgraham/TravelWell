//
//  AppProfile+CoreDataProperties.swift
//  TravelWell
//
//  Created by Callum Graham on 18/11/2021.
//
//

import Foundation
import CoreData


extension AppProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppProfile> {
        return NSFetchRequest<AppProfile>(entityName: "AppProfile")
    }

    @NSManaged public var endTime: Date?
    @NSManaged public var friday: Bool
    @NSManaged public var monday: Bool
    @NSManaged public var name: String?
    @NSManaged public var saturday: Bool
    @NSManaged public var startTime: Date?
    @NSManaged public var sunday: Bool
    @NSManaged public var thursday: Bool
    @NSManaged public var timeZone: String?
    @NSManaged public var tuesday: Bool
    @NSManaged public var wednesday: Bool

}

extension AppProfile : Identifiable {

}
