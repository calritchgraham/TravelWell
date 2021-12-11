//
//  Expense+CoreDataProperties.swift
//  TravelWell
//
//  Created by Callum Graham on 04/12/2021.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var currency: String?
    @NSManaged public var amount: Double
    @NSManaged public var occasion: String?
    @NSManaged public var date: Date?
    @NSManaged public var trip: Trip?
    @NSManaged public var image: Data?

}

extension Expense : Identifiable {

}
