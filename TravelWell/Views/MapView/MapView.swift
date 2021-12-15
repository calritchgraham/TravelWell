//
//  MapView.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    @State var region : MKCoordinateRegion
    @State var accom  : [Location]
    @State var searchTerm = ""
    var currTrip : Trip

    var body: some View {
        VStack{
            Map(coordinateRegion: $region , showsUserLocation: true, annotationItems: accom) { place in
                MapMarker(coordinate: place.coordinate, tint: Color.purple)
            }.ignoresSafeArea()
            HStack{
                TextField("Search for...", text: $searchTerm)
                if searchTerm != "" {
                    NavigationLink(destination: MapSearchView(searchTerm: searchTerm, accom: accom, region: region, currTrip: currTrip)){
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                }
            }.frame(height: 50.00)
        }
    }
}

