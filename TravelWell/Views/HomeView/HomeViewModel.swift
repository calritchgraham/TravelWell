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
    
    private var profile : [AppProfile]?
    private var trips : [Trip]?
    var managedObjectContext = PersistenceController.shared.container.viewContext
    @Published var onATrip = false
    @StateObject private var locationServicesModel = LocationServicesModel()
    @Published var region = MKCoordinateRegion()
    @Published var currTrip : Trip?
    @Published var accom = [Location]()
    @Published var currCoords : CLLocationCoordinate2D?
    @Published var selection: Int? = nil
    @Published var occasion = ""
    @Published var amount = ""
    @Published var currency = ""
    var isoCurrencyCodes = Locale.commonISOCurrencyCodes
    @Published var exchangeRates :  ExchangeRates?
    @Published var availablePD = 0.0
    var todayExpenses = [Expense]()
    
    func setPersistentData(profile: [AppProfile], trips: [Trip]){
        self.trips = trips
        self.profile = profile
    }
    
    func fetchStoredData(){
        let fetchRequestTrip: NSFetchRequest<Trip>
        fetchRequestTrip = Trip.fetchRequest()
        let context = managedObjectContext
        trips = try! context.fetch(fetchRequestTrip)
        
        let fetchRequestProfile: NSFetchRequest<AppProfile>
        fetchRequestProfile = AppProfile.fetchRequest()
        profile = try! context.fetch(fetchRequestProfile)
    }
    
    func removeExpense(expense: Expense){
        
        for i in 0...(todayExpenses.count - 1){
            if todayExpenses[i] == expense {
                todayExpenses.remove(at: i)
            }
        }
        self.calculatePerDiem()
    }

    func saveExpense(){
        let expense = Expense(context: managedObjectContext)
        expense.currency = currency
        expense.occasion = occasion
        expense.date = Date()           //can only add expenses for today
        expense.amount = Double(amount) ?? 0.0
        expense.trip = currTrip
        PersistenceController.shared.save()
        todayExpenses.append(expense)
        currency = ""
        amount = ""
        occasion = ""
        self.calculatePerDiem()
        
        
    }
    
    func filterExpense(){   //only show todays expenses on home screen
        if currTrip?.expense != nil {
            let today = Date()
            let formatter = DateFormatter()         //filter by string as Date() includes time component
            formatter.dateStyle = .short
            let todayString = formatter.string(from: today)
        
            for expense in Array(currTrip!.expense! as! Set<Expense>){
                if !todayExpenses.contains(expense) {
                    if todayString == formatter.string(from: (expense).date!) {
                        todayExpenses.append(expense)
                    }
                }
            }
        }
    }
    
    func getExchangeRates(){
        if profile?.first?.localCurr != nil {
            let url = "https://open.er-api.com/v6/latest/"          //open API
            let completeURL = url + (profile?.first?.localCurr)!    //cant save without currency
            guard let callURL = URL(string: completeURL) else { fatalError("Missing URL") }
            let urlRequest = URLRequest(url: callURL)

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }

                guard let response = response as? HTTPURLResponse else { return }

                if response.statusCode == 200 {     //success
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
    }
    
    func calculatePerDiem(){
        
        availablePD = profile?.first!.perDiem ?? 0.0 //negative amount shown if none set
        if exchangeRates != nil{
            for expense in todayExpenses{
                for (currency, rate) in exchangeRates!.rates{
                    if expense.currency == currency{
                        availablePD -= (expense.amount/rate)
                    }
                }
            }
        }else{
            self.getExchangeRates()
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
                return Date() //current time at location
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
                    self.filterExpense()
                }
            }
        }else{
            self.onATrip = false
        }
    }
    
    func mapInitiate(){
         if onATrip == true{
             locationServicesModel.checkLocationServicesEnabled()
             let accomPin = Location(coordinate: CLLocationCoordinate2D(latitude: currTrip!.lat, longitude: currTrip!.long))
             self.accom.append(accomPin)
             currCoords = CLLocationCoordinate2D(latitude: currTrip!.lat, longitude: currTrip!.long)
//           use this to centre map on current locaton rather than accomodation location
//             while currCoords == nil {
//                 self.currCoords = mapViewModel.locationManager?.location?.coordinate
//             }
             //mapViewModel.locationManager?.stopUpdatingLocation() //saves battery?
             self.region = MKCoordinateRegion(center: currCoords! , span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
         }
     }
    
}
