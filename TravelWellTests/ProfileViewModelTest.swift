//
//  ProfileViewModelTest.swift
//  TravelWellTests
//
//  Created by Callum Graham on 10/12/2021.
//

import XCTest
import SwiftUI
import CoreData
@testable import TravelWell

class ProfileViewModelTest: XCTestCase {
    
    var profileViewModel: ProfileViewModel!
    var managedObjectContext = PersistenceController.shared.container.viewContext
    let persistenceController = TestingEnvironmentPersistenceController()

    override func setUp() {
        profileViewModel = ProfileViewModel()
        createData()
    }
    
    func createData() {
        let newProfile = NSEntityDescription.insertNewObject(forEntityName: "AppProfile", into: managedObjectContext) as! AppProfile
        newProfile.perDiem = 50
        newProfile.localCurr = "GBP"
        newProfile.hasPD = true
        newProfile.timeZone = "Europe/London"
        
        profileViewModel.setProfile(profile: newProfile)
    }

    override func tearDown() {
        profileViewModel = nil
    }

    func testProfileView() throws {
        XCTAssertEqual("GBP", profileViewModel.localCurr)
        XCTAssertEqual("Europe/London", profileViewModel.profile?.timeZone)
        XCTAssertTrue(profileViewModel.hasPD)
    }
}
