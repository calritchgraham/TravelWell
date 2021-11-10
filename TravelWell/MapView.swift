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

    var body: some View {
        VStack{
            Map(coordinateRegion: $region , showsUserLocation: true, annotationItems: accom) { place in
                MapMarker(coordinate: place.coordinate, tint: Color.purple)
            }.ignoresSafeArea()
            HStack{
                TextField("Search for...", text: $searchTerm)
                NavigationLink(destination: MapSearchView(searchTerm: searchTerm, region: region, accom: accom)){
                    Image(systemName: "magnifyingglass.circle.fill")
                }
            }.frame(height: 50.00)
        }
    }
}

