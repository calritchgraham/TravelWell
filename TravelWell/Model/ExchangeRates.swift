//
//  ExchangeRates.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import Foundation

struct ExchangeRates: Codable {
    let baseCode: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case rates
    }
}
