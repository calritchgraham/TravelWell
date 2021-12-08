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

    @NSManaged public var timeZone: String?
    @NSManaged public var hasPD: Bool
    @NSManaged public var localCurr: String
    @NSManaged public var perDiem: Double

}

extension AppProfile : Identifiable {

}
