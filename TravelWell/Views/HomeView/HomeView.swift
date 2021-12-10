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
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    func removeExpense(at offsets: IndexSet){
        for index in offsets {
            let expense = homeViewModel.allExpenses[index]
            PersistenceController.shared.delete(expense)
            homeViewModel.removeExpense(expense: expense)
        }
    }

    var body: some View {
        NavigationView {
            if !homeViewModel.onATrip {
                if trips.isEmpty{
                    Text("You have no upcoming trips")
                    NavigationLink(destination: AddTripView()){
                      Text("Add a Trip")
                    }
                }else{
                    Text("Your next trip is in \(abs((Calendar.current.dateComponents([.day], from: trips.first!.outbound!, to: Date())).day!)) days").onAppear{
                        homeViewModel.isOnATrip()
                    }
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
                                Text("\(profile.first?.localCurr ?? "XXX")")
                                Spacer()
                                Text("\(String(format: "%.2f", homeViewModel.availablePD))") //2 decimal point
                            }
                        }else{
                            HStack{
                                Text("Total Spend")
                                Spacer()
                                Text("\(profile.first?.localCurr ?? "XXX")")
                                Spacer()
                                Text("\(String(format: "%.2f", abs(homeViewModel.availablePD)))") //2 decimal point
                            }
                        }
                        
                        Form{
                            HStack{
                                TextField("Occasion", text: $homeViewModel.occasion)
                                
                                Picker("Local Currency", selection: $homeViewModel.currency) {
                                    ForEach(homeViewModel.isoCurrencyCodes, id: \.self) {
                                      Text($0)
                                    }
                                }
                                        
                                TextField("Amount", text: $homeViewModel.amount).keyboardType(.decimalPad)
                                
                                if homeViewModel.amount != "" && homeViewModel.occasion != "" && homeViewModel.currency != ""{
                                    Image(systemName: "square.and.arrow.down.fill").onTapGesture {
                                        homeViewModel.saveExpense()
                                        hideKeyboard()
                                    }
                                }
                            }
                        }
                        
                        
                        List {
                            ForEach(homeViewModel.allExpenses, id:\.self) { currentExpense in
                                HStack{
                                    Text("\(currentExpense.occasion ?? "Unknown")")
                                    Text("\(currentExpense.currency ?? "Unknown")")
                                    Spacer()
                                    Text("\(String(currentExpense.amount))")
                                }
                            }.onDelete(perform: removeExpense)
                        }

                        if homeViewModel.currTrip != nil && homeViewModel.currTrip?.favourite != nil {
                            Section{
                                Text("Starred Places")
                        
                                List {
                                    ForEach(Array(homeViewModel.currTrip!.favourite as! Set<Favourite>), id:\.self) { item in
                                        if item.name != nil{
                                            NavigationLink(destination: MapView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), latitudinalMeters: 1000.0, longitudinalMeters: 1000.0), accom: homeViewModel.accom, currTrip: homeViewModel.currTrip!)){
                                                VStack{
                                                    HStack{
                                                        Text(item.name ?? "Unknown").bold()
                                                    }
                                                    HStack{
                                                        Text("Distance from accomodation")
                                                        Spacer()
                                                        Text("\((Int((((CLLocation(latitude: item.lat, longitude: item.long).distance(from: (CLLocation(latitude: homeViewModel.currTrip!.lat, longitude: homeViewModel.currTrip!.long))))))))) m")
                                                    }
                                                    
                                            }.onTapGesture{
                                                homeViewModel.accom.append(Location(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)))
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                        
                }
            }
        }.navigationBarHidden(true)
            .onAppear{
                homeViewModel.fetchStoredData()
                homeViewModel.filterExpense()
                if homeViewModel.exchangeRates == nil{
                    homeViewModel.getExchangeRates()
                }else{
                    homeViewModel.calculatePerDiem()
                }
                homeViewModel.isOnATrip()
                
            }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

