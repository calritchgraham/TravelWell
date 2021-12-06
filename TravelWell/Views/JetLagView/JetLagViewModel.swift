//
//  JetLagViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import Foundation
import SwiftUI

final class JetLagViewModel : ObservableObject {
    var trip : Trip?
    private var profile : FetchedResults<AppProfile>?
    @Published var easternTravel = false
    @Published var diffInSeconds = 0
    let oneDayInSecs : Double = -60 * 60 * 24
    let oneHourInSecs : Double = -60 * 60
    @Published var oneDayBefore = Date()
    @Published var twoDaysBefore = Date()
    @Published var dayAfter = Date()
    @Published var today = Date()
    
    func setPersistentData(profile: FetchedResults<AppProfile>){
        self.profile = profile
    }
    
    func setTrip(trip: Trip){
        self.trip = trip
    }
    
    
    func calcTimeDiff(){            //back to back trips?
        if !profile!.isEmpty{
            let homeTZ = TimeZone(identifier: (profile?.first?.timeZone)!)
            let tripTZ = TimeZone(identifier: (trip?.timeZone)!)
            diffInSeconds = tripTZ!.secondsFromGMT() - homeTZ!.secondsFromGMT()
            oneDayBefore = (trip?.outbound?.advanced(by: oneDayInSecs))!
            twoDaysBefore = (trip?.outbound?.advanced(by: -oneDayInSecs).advanced(by: -oneDayInSecs))!
            dayAfter = (trip?.outbound?.advanced(by: abs(oneDayInSecs)))!
        }
        
        if (diffInSeconds < 0){
            easternTravel = true
            diffInSeconds = abs(diffInSeconds)
        }
    }
    
}
