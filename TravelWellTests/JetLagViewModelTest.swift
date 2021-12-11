//
//  JetLagViewModelTest.swift
//  TravelWellTests
//
//  Created by Callum Graham on 10/12/2021.
//

import XCTest
import CoreData
@testable import TravelWell

class JetLagViewModelTest: XCTestCase {
    var jetLagViewModel: JetLagViewModel!
    var managedObjectContext = PersistenceController.shared.container.viewContext

    override func setUp() {
        jetLagViewModel = JetLagViewModel()
        createData()
    }

    override func tearDown() {
        jetLagViewModel = nil
    }

    func testJetLagModel() throws {
        jetLagViewModel.calcTimeDiff()
        XCTAssertTrue(jetLagViewModel.easternTravel)
    }
    
    func createData() {
        let trip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: managedObjectContext) as! Trip
        trip.outbound = Date()
        trip.inbound = Date().advanced(by: 7 * 24 * 60 * 60)
        trip.accomName = "The Peninsula Hong Kong"
        trip.accomAddress =  "Salisbury Rd, Tsim Sha Tsui, Hong Kong"
        trip.destination = "HK"
        trip.timeZone = "Asia/Hong_Kong"
        trip.lat = 114.1719
        trip.long = 22.2951
        jetLagViewModel.setTrip(trip: trip)
        
        let newProfile = NSEntityDescription.insertNewObject(forEntityName: "AppProfile", into: managedObjectContext) as! AppProfile
        newProfile.perDiem = 65
        newProfile.localCurr = "EUR"
        newProfile.hasPD = true
        newProfile.timeZone = "Europe/Lisbon"
        jetLagViewModel.setProfile(profile: newProfile)
    }
}
