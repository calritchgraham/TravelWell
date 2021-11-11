//
//  TripView.swift
//  diss
//
//  Created by Callum Graham on 19/10/2021.
//

import SwiftUI
import CoreData
import CoreLocation

/*
 delete trip
 add details not already present
 
 */
struct TripView: View {
 
    let mapViewController = MapViewController()
    
    @State var trip : Trip
    
    
    var body: some View {
        VStack{
            Text(trip.accomAddress!)
            Text(trip.destination!)
        }.onAppear{
            mapViewController.getSafetyRating(trip: trip)
        }
    }
}
