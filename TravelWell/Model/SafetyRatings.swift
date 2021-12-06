//
//  SafetyRatings.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import Foundation

struct SafetyRating {
    var safetyScores = SafetyScore()
    var name = ""
}

struct SafetyScore{
    var lgbtq = 0
    var theft = 0
    var physicalHarm = 0
    var women = 0
    var overall = 0
}
