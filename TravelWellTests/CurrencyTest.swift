//
//  CovidDataTest.swift
//  TravelWellTests
//
//  Created by Callum Graham on 03/12/2021.
//

import XCTest
@testable import TravelWell

class CurrencyTest: XCTestCase {
    
    func testCanParseCurrency() {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "CurrencyJSON", ofType: "json") else { fatalError("json not found")}
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {fatalError("unable to convert file to string")}
        
        let jsonData = json.data(using: .utf8)!
        let currencyResults = try! JSONDecoder().decode(ExchangeRates.self, from: jsonData)
        
        var sar = 0.0
        var gbp = 0.0
        
        for (currency, rate) in currencyResults.rates{
            if currency == "SAR" {
                sar = rate
            }
            if currency == "GBP" {
                gbp = rate
            }
        }

        
        XCTAssertEqual(0.542, gbp)
        XCTAssertEqual(2.68, sar)

    }
}
