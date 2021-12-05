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
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    @FetchRequest(entity: Trip.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Trip.outbound, ascending: true)]
                        ) var trips: FetchedResults<Trip>
    @FetchRequest(entity: Expense.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: true)]
                        ) var expenses: FetchedResults<Expense>
    
    let today = Date()
    @State var onATrip = false
    @StateObject private var mapViewController = MapViewController()
    @State var region = MKCoordinateRegion()
    @State var currTrip = Trip()
    @State var accom = [Location]()
    @State var currCoords : CLLocationCoordinate2D?
    @State var selection: Int? = nil
    @State var occasion = ""
    @State var amount = ""
    @State var currency = ""
    var isoCurrencyCodes = Locale.commonISOCurrencyCodes
    @State var exchangeRates :  ExchangeRates?
    @State var availablePD = 0.0
    
    
    func saveExpense(){
        let expense = Expense(context: managedObjectContext)
        expense.currency = currency
        expense.occasion = occasion
        expense.date = Date()
        expense.amount = Double(amount) ?? 0.0
        PersistenceController.shared.save()
        currency = ""
        amount = ""
        occasion = ""
        self.calculatePerDiem()
        
        
    }
    
    func removeExpense(at offsets: IndexSet){
        for index in offsets {
            let expense = expenses[index]
            PersistenceController.shared.delete(expense)
        }
    }

    
    func filterExpense(){
        //date
    }
    
    func getExchangeRates(){
        let url = "https://open.er-api.com/v6/latest/"
        let currency = "AED" //(profile.first?.localCurr)!
        print(profile.first?.localCurr)   //fix this once profile is set up
        let completeURL = url + currency
        guard let callURL = URL(string: completeURL) else { fatalError("Missing URL") }
        let urlRequest = URLRequest(url: callURL)

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        self.exchangeRates = try JSONDecoder().decode(ExchangeRates.self, from: data)
                        print("hello")
                        self.calculatePerDiem()
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func calculatePerDiem(){
        availablePD = profile.first?.perDiem ?? 0.0 //negative amount shown if none set
        for expense in expenses{
            for (currency, rate) in exchangeRates!.rates{
                if expense.currency == currency{
                    availablePD -= (expense.amount/rate)
                }
            }
        }
    }

    
    var body: some View {
        if(!profile.isEmpty){
            NavigationView {
                VStack{
                    if onATrip{
                        HStack{
                            Text("The time at home is:")
                            Spacer()
                            Text(getHomeTime(), style: .time)
                        }
                        
                        Text("Expenses")
                        
                        HStack{
                            Text("Available Per Diem:")
                            Spacer()
                            Text("\(availablePD)") //2 decimal point
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
                            TextField("Occasion", text: $occasion)
                        }
                        HStack{
                            Form{
                                TextField("Amount", text: $amount)
                            }.keyboardType(.decimalPad)
                            Form { //selection of two, home and local??
                              Picker("Local Currency", selection: $currency) {
                                  ForEach(isoCurrencyCodes, id: \.self) {
                                      Text($0)
                                  }
                              }
                            }
                            if amount != "" && occasion != "" && currency != ""{
                                Image(systemName: "square.and.arrow.down.fill").onTapGesture {
                                    self.saveExpense()
                                }
                                
                            }
                        }
                        
                        NavigationLink(destination: MapView(region: region, accom: accom, currTrip: currTrip)){
                                Map(coordinateRegion: $region , showsUserLocation: true, annotationItems: accom) { place in
                                    MapMarker(coordinate: place.coordinate, tint: Color.purple)
                                }.frame(width: 400, height: 300).onAppear{
                                    self.mapInitiate()
                                    self.getExchangeRates()
                                    //self.filterExpense()
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
                    self.getExchangeRates()
                    
                    }
                //}
            }.navigationBarHidden(true)
        }else{
            Text("Please complete your profile.")
        }
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
             //print(expenses.first)
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

struct ExchangeRates: Codable {
    let baseCode: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case rates
    }
}
