//
//  HomeViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 05/12/2021.
//
import SwiftUI
import CoreData
import MapKit

final class HomeViewModel : ObservableObject{
    
    private var profile : FetchedResults<AppProfile>?
    private var trips : FetchedResults<Trip>?
    private var expenses : FetchedResults<Expense>?
    
    var managedObjectContext = PersistenceController.shared.container.viewContext
    @Published var onATrip = false
    @StateObject private var mapViewController = MapViewController()
    @Published var region = MKCoordinateRegion()
    @Published var currTrip = Trip()
    @Published var accom = [Location]()
    @Published var currCoords : CLLocationCoordinate2D?
    @Published var selection: Int? = nil
    @Published var occasion = ""
    @Published var amount = ""
    @Published var currency = ""
    var isoCurrencyCodes = Locale.commonISOCurrencyCodes
    @Published var exchangeRates :  ExchangeRates?
    @Published var availablePD = 0.0
    
    func setPersistentData(profile: FetchedResults<AppProfile>, trips: FetchedResults<Trip>, expenses: FetchedResults<Expense>){
        self.trips = trips
        self.expenses = expenses
        self.profile = profile
    }
    
    
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
    
    func filterExpense(){
        //date
    }
    
    func getExchangeRates(){
        let url = "https://open.er-api.com/v6/latest/"
        let currency = (profile?.first?.localCurr)!
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
        availablePD = profile?.first?.perDiem ?? 0.0 //negative amount shown if none set
        for expense in expenses!{
            for (currency, rate) in exchangeRates!.rates{
                if expense.currency == currency{
                    availablePD -= (expense.amount/rate)
                }
            }
        }
    }
    
    func getHomeTime() -> Date{
        if(profile?.isEmpty == false){
            if(profile?.first?.timeZone != ""){
                let homeTZ = profile?.first?.timeZone!
                let increment = (TimeZone(identifier: homeTZ!)?.secondsFromGMT())! - TimeZone.current.secondsFromGMT()
                let timeAtHome  = Calendar.current.date(byAdding: .second, value: increment, to: Date())!
                return timeAtHome
            }else{
                return Date()
            }
        }
        return Date()
    }
    
    func isOnATrip(){
        if (!trips!.isEmpty){
            for trip in trips!{
                if (trip.outbound! <= Date() && trip.inbound! >= Date()){
                    self.currTrip = trip
                    self.onATrip = true
                }
            }
        }
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
