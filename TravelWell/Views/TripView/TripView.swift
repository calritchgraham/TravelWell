//
//  TripView.swift
//  diss
//
//  Created by Callum Graham on 19/10/2021.
//

import SwiftUI
import MapKit

struct TripView: View {
    @State var trip : Trip
    @State var isLoading = true
    @StateObject private var tripViewModel = TripViewModel()

    var body: some View {
        VStack{
            if isLoading{
                Text("Loading...").onAppear{
                    tripViewModel.setTrip(trip: trip)
                    tripViewModel.populateFavourites()
                    self.isLoading = false
                }
            }else{
                Text(tripViewModel.trip.accomName!).bold()
                NavigationLink(destination: JetLagView(trip: tripViewModel.trip)){
                    Text("Jet Lag Management Information")
                }
            
                
                NavigationLink(destination: MapView(region: tripViewModel.region, accom: tripViewModel.accom, currTrip: trip)){
                    Map(coordinateRegion: $tripViewModel.region , showsUserLocation: true, annotationItems: tripViewModel.accom) { place in
                            MapMarker(coordinate: place.coordinate, tint: Color.purple)
                        }.frame(width: 400, height: 300).onAppear{
                            tripViewModel.mapInitiate()
                        }
                }.onAppear{
                    tripViewModel.getSafetyRating(trip: trip)
                    tripViewModel.getCovidRestrictions(country: trip.destination!)
                    tripViewModel.mapInitiate()
                }
                if !tripViewModel.safetyRatings.isEmpty {
                    HStack{
                        Text("\(tripViewModel.safetyRatings.first!.name) Safety Ratings").onAppear{
                            tripViewModel.mapSafetyScore()
                        }
                        Spacer()
                        if !tripViewModel.showSafety {
                            Image(systemName: "plus.circle").onTapGesture{
                                tripViewModel.showSafety.toggle()
                            }
                        }else{
                            Image(systemName: "minus.circle").onTapGesture{
                                tripViewModel.showSafety.toggle()
                            }
                        }
                        
                    }
                    if tripViewModel.showSafety{
                        List{
                            HStack{
                                Text("Overall")
                                Spacer()
                                Text(tripViewModel.overall)
                            }
                            HStack{
                                Text("Theft")
                                Spacer()
                                Text(tripViewModel.theft)
                            }
                            HStack{
                                Text("Physical Harm")
                                Spacer()
                                Text(tripViewModel.physicalHarm)
                            }
                            HStack{
                                Text("Women")
                                Spacer()
                                Text(tripViewModel.women)
                            }
                            HStack{
                                Text("LGBTQ")
                                Spacer()
                                Text(tripViewModel.lgbt)
                            }
                        }.frame(height: 250)
                            // add animation
                    }
                }
                if tripViewModel.covidAvailable{
                    
                    NavigationLink(destination: CovidDataView(covidResults: tripViewModel.covidResults!)){
                        HStack{
                            Text("Covid Restrictions and Information")
                            Spacer()
                        
                        }
                    }
                }
                        
                Section{
                    Text("Starred Places")
            
                    List {
                        ForEach(tripViewModel.favourites, id:\.self) { item in
                            if item.name != nil {
                                NavigationLink(destination: MapView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), latitudinalMeters: 1000.0, longitudinalMeters: 1000.0), accom: tripViewModel.accom, currTrip: trip)){
                                    VStack{
                                        HStack{
                                            Text(item.name ?? "Unknown")
                                            Spacer()
                                            Image(systemName: "star.fill").onTapGesture{
                                                PersistenceController.shared.delete(item)
                                                tripViewModel.removeFavourite(favourite: item)
                                            }
                                        
                                        }
                                        HStack{
                                            Text("Distance from accomodation")
                                            Spacer()
                                            Text("\((Int((((CLLocation(latitude: item.lat, longitude: item.long).distance(from: (CLLocation(latitude: trip.lat, longitude: trip.long))))))))) m")
                                        }
                                    }.onTapGesture{ //not working
                                            //accom.append(Location(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)))
                                    }
                                }
                            }
                        }
                    }
                }.onDisappear{
                    self.isLoading = true
                }
            }
        }
    }
}



