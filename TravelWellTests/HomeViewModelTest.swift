//
//  HomeViewModelTest.swift
//  TravelWellTests
//
//  Created by Callum Graham on 08/12/2021.
//

import XCTest
import SwiftUI
import CoreData
@testable import TravelWell

class HomeViewModelTest: XCTestCase {
    
    var homeViewModel: HomeViewModel!
    var managedObjectContext = PersistenceController.shared.container.viewContext
    let persistenceController = TestingEnvironmentPersistenceController()
    
    override func setUp() {
        
        homeViewModel = HomeViewModel()
        createData()
    }

    override func tearDown() {
        
        homeViewModel = nil
        
    }
    
    func testOnATrip(){
        homeViewModel.isOnATrip()
        XCTAssertTrue(homeViewModel.onATrip)
    }
    func testGetExchangeRates(){
        homeViewModel.getExchangeRates()
        XCTAssertTrue(homeViewModel.availablePD < 50.00)
    }
    
    func createData() {
       
        let trip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: managedObjectContext) as! Trip
        trip.outbound = Date()
        trip.inbound = Date().advanced(by: 7 * 24 * 60 * 60)
        trip.accomName = "The Peninsula Hong Kong"
        trip.accomAddress =  "Salisbury Rd, Tsim Sha Tsui, Hong Kong"
        trip.destination = "HK"
        trip.lat = 114.1719
        trip.long = 22.2951
        
        
        let favourite = NSEntityDescription.insertNewObject(forEntityName: "Favourite", into: managedObjectContext) as! Favourite
        favourite.trip = trip
        favourite.lat = 114.1713
        favourite.long = 22.3151
        favourite.name = "Amazing Life"
        
        let favSet = NSSet(object: favourite)
        trip.favourite = favSet
        
        let yesterdayExpense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: managedObjectContext) as! Expense
        yesterdayExpense.trip = trip
        yesterdayExpense.currency = "HKD"
        yesterdayExpense.occasion = "Cocktail"
        yesterdayExpense.date = Date().advanced(by: -24 * 60 * 60)
        yesterdayExpense.amount = 140
        
        let expense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: managedObjectContext) as! Expense
        expense.trip = trip
        expense.currency = "HKD"
        expense.date = Date()
        expense.amount = 40
        expense.occasion = "Coffee"
        
        let expSet = NSSet(object: expense)
        trip.expense = expSet
        
        let newProfile = NSEntityDescription.insertNewObject(forEntityName: "AppProfile", into: managedObjectContext) as! AppProfile
        newProfile.perDiem = 50
        newProfile.localCurr = "GBP"
        newProfile.hasPD = true
        newProfile.timeZone = "Europe/London"
        
        //persistenceController.save()
        
        let fetchRequestTrip: NSFetchRequest<Trip>
        fetchRequestTrip = Trip.fetchRequest()
        let context = managedObjectContext
        let trips = try! context.fetch(fetchRequestTrip)
        
        let fetchRequestProfile: NSFetchRequest<AppProfile>
        fetchRequestProfile = AppProfile.fetchRequest()
        let profiles = try! context.fetch(fetchRequestProfile)
        homeViewModel.setPersistentData(profile: profiles, trips: trips)
    }

}
 
