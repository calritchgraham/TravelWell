//
//  TripViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 05/12/2021.
//

import Foundation
import SwiftUI
import CoreData
import CoreLocation
import MapKit
import Amadeus


final class TripViewModel: ObservableObject{
    var amadeus = Amadeus(
        client_id: "",//7P3QGlemZJYXrhl7BAvAQODOGFuMhMWZ",
        client_secret: "G5Gov3YpWeAytXpm")
    
    @Published var overall = ""
    @Published var theft = ""
    @Published var physicalHarm = ""
    @Published var women = ""
    @Published var lgbt = ""
    let locationServicesModel = LocationServicesModel()
    @Published var trip = Trip()
    @Published var accom = [Location]()
    @Published var region = MKCoordinateRegion()
    @Published var safetyRatings = [SafetyRating]()
    @Published var showSafety = false
    @Published var covidAvailable = false
    @Published var showCovid = false
    @Published var covidResults : CovidData?
    @Published var favourites = [Favourite]()
    var managedObjectContext = PersistenceController.shared.container.viewContext
    
    func setTrip(trip: Trip){
        self.trip = trip
    }
    
    
    func mapInitiate(){
        locationServicesModel.checkLocationServicesEnabled()
        let accomPin = Location(coordinate: CLLocationCoordinate2D(latitude: trip.lat, longitude: trip.long))
        self.accom.append(accomPin)
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: trip.lat, longitude: trip.long), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
    func populateFavourites(){
        if trip.favourite  != nil{
            for favourite in Array(trip.favourite! as! Set<Favourite>){
                if !favourites.contains(favourite){
                    favourites.append(favourite)
                }
            }
        }
    }
    
    func removeFavourite(favourite: Favourite){
        for i in 0...(favourites.count-1){
            if favourites[i] == favourite {
                favourites.remove(at: i)
            }
        }
        
    }
    
    func getSafetyRating(trip: Trip){
        let params = ["latitude": "\(trip.lat)", "longitude": "\(trip.long)"]
        self.amadeus.safety.safetyRatedLocations.get(params: params) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.updateSR(response: response)  //SafetuyRating does not confirm to Codable, decode manually
                }
            case .failure(let error):
                print("Error fetching safety ratings - \(error.localizedDescription)")
                return
            }
        }
    }
    
    func updateSR(response: Response){
        var safetyR = SafetyRating()
        for safetyRating in response.data.arrayValue {
            safetyR.name = safetyRating["name"].stringValue
            safetyR.safetyScores.lgbtq = safetyRating["safetyScores"]["lgbtq"].intValue
            safetyR.safetyScores.theft = safetyRating["safetyScores"]["theft"].intValue
            safetyR.safetyScores.physicalHarm = safetyRating["safetyScores"]["physicalHarm"].intValue
            safetyR.safetyScores.women = safetyRating["safetyScores"]["women"].intValue
            safetyR.safetyScores.overall = safetyRating["safetyScores"]["overall"].intValue
            safetyRatings.append(safetyR)
        }
    }
    
   
    func getCovidRestrictions(country: String){
        let params = ["countryCode": "\(country)"]

        amadeus.client.get(path:"v1/duty-of-care/diseases/covid19-area-report",
                    params: params, onCompletion: { result in
            switch result{
            case .success(let response):
                let data = Data(response.body.utf8)
                self.covidResults = try! JSONDecoder().decode(CovidData.self, from: data)  
                self.covidAvailable = true
            case.failure(let error):
                print("Error covid info - \(error.localizedDescription)")
                
            }
        })
    }
    
    func mapSafetyScore(){
        let scores = safetyRatings.first?.safetyScores
        self.lgbt = stringSafetyScores(int: scores!.lgbtq)
        self.theft = stringSafetyScores(int: scores!.theft)
        self.physicalHarm = stringSafetyScores(int: scores!.physicalHarm)
        self.women = stringSafetyScores(int: scores!.women)
        self.overall = stringSafetyScores(int: scores!.overall)
    }
    
    func stringSafetyScores(int :Int)-> String{
        if int < 34{
            return "Low"
        }else if int < 67{
            return "Medium"
            
        }else{
            return "High"
        }
    }
}
