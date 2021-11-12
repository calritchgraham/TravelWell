//
//  HomeView.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//

import SwiftUI
import CoreData
import MapKit
import CoreLocation

struct HomeView: View {
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    @FetchRequest(entity: Trip.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Trip.outbound, ascending: true)]
                        ) var trips: FetchedResults<Trip>
    
    let today = Date()
    @State var onATrip = false
    @StateObject private var mapViewController = MapViewController()
    @State var region = MKCoordinateRegion()
    @State var currTrip = Trip()
    @State var accom = [Location]()
    @State var currCoords : CLLocationCoordinate2D?
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView{
            VStack{
                if onATrip{
                    Text("The time at home is")
                    Text(getHomeTime(), style: .time)
                    
                    NavigationLink(destination: MapView(region: region, accom: accom, currTrip: currTrip)){
                            Map(coordinateRegion: $region , showsUserLocation: true, annotationItems: accom) { place in
                                MapMarker(coordinate: place.coordinate, tint: Color.purple)
                            }.frame(width: 400, height: 300).onAppear{
                                self.mapInitiate()
                            }
                    }

                    
                }else{
                    if trips.isEmpty{
                        Text("You have no upcoming trips")
                    }else{
                        Text("Your next trip is in \(abs((Calendar.current.dateComponents([.day], from: trips[0].outbound!, to: today)).day!)) days")
                    }
                }
                Spacer()
                
            }.onAppear{
                onATrip = self.isOnATrip()
            }
        }.navigationBarHidden(true)
    }
    
    func getHomeTime() -> Date{
        if(profile.isEmpty == false){
            if(profile[0].timeZone != ""){
                let homeTZ = profile[0].timeZone!
                let increment = TimeZone(identifier: homeTZ)?.secondsFromGMT()
                let timeAtHome  = Calendar.current.date(byAdding: .second, value: increment!, to: today)!
                return timeAtHome
            }else{
                return Date()
            }
        }
        return Date()
    }
    
    func isOnATrip() -> Bool {
        if (trips.isEmpty == false){
            for trip in trips{
                if (trip.outbound! <= today && trip.inbound! >= today){
                    self.currTrip = trip
                    return true
                }
            }
        }
        return false
    }
    
    func mapInitiate(){
         if onATrip == true{
             mapViewController.checkLocationServicesEnabled()
             let accomPin = Location(coordinate: CLLocationCoordinate2D(latitude: currTrip.lat, longitude: currTrip.long))
             self.accom.append(accomPin)
             currCoords = CLLocationCoordinate2D(latitude: currTrip.lat, longitude: currTrip.long)
//             while currCoords == nil {
//                 self.currCoords = mapViewModel.locationManager?.location?.coordinate
//             }
             //mapViewModel.locationManager?.stopUpdatingLocation() //saves battery?
             self.region = MKCoordinateRegion(center: currCoords! , span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
         }
     }
}

struct Location: Identifiable {
  let id = UUID()
  let coordinate: CLLocationCoordinate2D
}
