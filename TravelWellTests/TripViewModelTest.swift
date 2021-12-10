//
//  TripViewModelTest.swift
//  TravelWellTests
//
//  Created by Callum Graham on 10/12/2021.
//

import XCTest
@testable import TravelWell

class TripViewModelTest: XCTestCase {
    var tripViewModel = TripViewModel()
    

    func testSafetyRatingsMapping() {
        let low = tripViewModel.stringSafetyScores(int: 26)
        let medium = tripViewModel.stringSafetyScores(int: 35)
        let high = tripViewModel.stringSafetyScores(int: 77)
        
        XCTAssertEqual("Low", low)
        XCTAssertEqual("Medium", medium)
        XCTAssertEqual("High", high)
        
    }
}
