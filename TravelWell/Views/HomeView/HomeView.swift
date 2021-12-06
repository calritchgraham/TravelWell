//
//  HomeView.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//

import SwiftUI
import CoreData
import MapKit

struct HomeView: View {
    
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    @FetchRequest(entity: Trip.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Trip.outbound, ascending: true)]
                        ) var trips: FetchedResults<Trip>
    @FetchRequest(entity: Expense.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: true)]
                        ) var expenses: FetchedResults<Expense>
    
    @StateObject private var homeViewModel = HomeViewModel()
    
   
    
    func removeExpense(at offsets: IndexSet){
        for index in offsets {
            let expense = expenses[index]
            PersistenceController.shared.delete(expense)
        }
    }
    
    var body: some View {
        NavigationView {
            if !homeViewModel.onATrip {
                Text("Loading...").onAppear{
                    homeViewModel.setPersistentData(profile: profile, trips: trips, expenses: expenses)
                    homeViewModel.calculatePerDiem()
                    homeViewModel.getExchangeRates()
                    //self.filterExpense()
                    homeViewModel.isOnATrip()
                    
                }
            }else {
                VStack{
                    if profile.isEmpty{
                        Text("Please complete your profile...")
                    }else if homeViewModel.onATrip{
                        HStack{
                            Text("The time at home is:")
                            Spacer()
                            Text(homeViewModel.getHomeTime(), style: .time)
                        }
                        
                        Text("Today's Expenses")
                        if profile.first?.hasPD != nil && profile.first?.hasPD == true{
                            HStack{
                                Text("Available Per Diem:")
                                Spacer()
                                Text("\(homeViewModel.availablePD)") //2 decimal point
                            }
                        }
                        
                        List {
                            ForEach(expenses, id:\.self) { currentExpense in
                                HStack{
                                    Text("\(currentExpense.occasion ?? "Unknown")")
                                    Text("\(currentExpense.currency ?? "Unknown")")
                                    Spacer()
                                    Text("\(String(currentExpense.amount))")
                                }
                            }.onDelete(perform: removeExpense)
                        }
                        
                        Form{
                            TextField("Occasion", text: $homeViewModel.occasion)
                        }
                        HStack{
                            Form{
                                TextField("Amount", text: $homeViewModel.amount)
                            }.keyboardType(.decimalPad)
                            Form { //selection of two, home and local??
                                Picker("Local Currency", selection: $homeViewModel.currency) {
                                    ForEach(homeViewModel.isoCurrencyCodes, id: \.self) {
                                      Text($0)
                                  }
                              }
                            }
                            if homeViewModel.amount != "" && homeViewModel.occasion != "" && homeViewModel.currency != ""{
                                Image(systemName: "square.and.arrow.down.fill").onTapGesture {
                                    homeViewModel.saveExpense()
                                }
                                
                            }
                        }
                        
                        NavigationLink(destination: MapView(region: homeViewModel.region, accom: homeViewModel.accom, currTrip: homeViewModel.currTrip)){
                            Map(coordinateRegion: $homeViewModel.region , showsUserLocation: true, annotationItems: homeViewModel.accom) { place in
                                    MapMarker(coordinate: place.coordinate, tint: Color.purple)
                                }.frame(width: 400, height: 300)
                        }.onAppear{
                            homeViewModel.mapInitiate()
                        }
                        
                        Section{
                            Text("Starred Places")
                    
                            List {
                                ForEach(Array(homeViewModel.currTrip.favourite as! Set<Favourite>), id:\.self) { item in
                                    NavigationLink(destination: MapView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), latitudinalMeters: 1000.0, longitudinalMeters: 1000.0), accom: homeViewModel.accom, currTrip: homeViewModel.currTrip)){
                                        VStack{
                                            HStack{
                                                Text(item.name ?? "Unknown")
                                                Spacer()
                                                Image(systemName: "star.fill").onTapGesture{
                                                    PersistenceController.shared.delete(item) //fix this
                                                }
                                            
                                            }
                                            HStack{
                                                Text("Distance from accomodation")
                                                Spacer()
                                                Text("\((Int((((CLLocation(latitude: item.lat, longitude: item.long).distance(from: (CLLocation(latitude: homeViewModel.currTrip.lat, longitude: homeViewModel.currTrip.long))))))))) m")
                                            }
                                        }.onTapGesture{ //not working
                                                //accom.append(Location(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)))
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        if trips.isEmpty{
                            Text("You have no upcoming trips")
                            NavigationLink(destination: AddTripView()){
                              Text("Add a Trip")
                            }
                        }else{
                            Text("Your next trip is in \(abs((Calendar.current.dateComponents([.day], from: trips.first!.outbound!, to: Date())).day!)) days")
                        }
                    }
                    Spacer()
                }
            }
        }.navigationBarHidden(true)
    }
}




