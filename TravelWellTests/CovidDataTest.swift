//
//  CovidDataTest.swift
//  TravelWellTests
//
//  Created by Callum Graham on 08/12/2021.
//

import XCTest
@testable import TravelWell

class CovidDataTest: XCTestCase {
    
    func testCanParseCovid() {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "CovidJSON", ofType: "json") else { fatalError("json not found")}
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {fatalError("unable to convert file to string")}
        
        let jsonData = json.data(using: .utf8)!
        let covidResults = try! JSONDecoder().decode(CovidData.self, from: jsonData)
        
        XCTAssertEqual("Germany", covidResults.data.area.name)
        XCTAssertEqual("Yes", covidResults.data.areaAccessRestriction.mask.isRequired)

    }
}
