//
//  TripView.swift
//  diss
//
//  Created by Callum Graham on 19/10/2021.
//

import SwiftUI
import CoreData
import CoreLocation
import MapKit
import Amadeus
import SwiftyJSON

struct TripView: View {
    var amadeus = Amadeus(
        client_id: "as", //"WXIrygihAwXYGBTYB6UGoim91OAPQsdr",
        client_secret: "FNka9GNxUSuGreX2"
    )
    @State var overall = ""
    @State var theft = ""
    @State var physicalHarm = ""
    @State var women = ""
    @State var lgbt = ""
    let mapViewController = MapViewController()
    @State var trip : Trip
    @State var accom = [Location]()
    @State var region = MKCoordinateRegion()
    @State var filteredFavs = Set<Favourite>()
    @State var safetyRatings = [SafetyRating]()
    @State var showSafety = false
    @State var covidAvailable = false
    @State var showCovid = false
    @State var covidResults : CovidData?
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Favourite.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Favourite.name, ascending: true)]
                  
                        ) var favourites: FetchedResults<Favourite>  //sort by trip
    
    func mapInitiate(){
        let accomPin = Location(coordinate: CLLocationCoordinate2D(latitude: trip.lat, longitude: trip.long))
        self.accom.append(accomPin)
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: trip.lat, longitude: trip.long), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    }
    
    func getSafetyRating(trip: Trip){
        let params = ["latitude": "\(trip.lat)", "longitude": "\(trip.long)"]
        self.amadeus.safety.safetyRatedLocations.get(params: params) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.updateSR(response: response)
                }
            case .failure(let error):
                print("Error fetching safety ratings - \(error.localizedDescription)")
                return
            }
        }
    }
    
    func filterFavourite(){
        for starred in favourites{
            if starred.trip == trip {
                filteredFavs.insert(starred)
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
                covidResults = try! JSONDecoder().decode(CovidData.self, from: data)  //deal with nil values
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
    
    
    var body: some View {
        VStack{
            NavigationLink(destination: JetLagView(trip: trip)){
                Text("Jet Lag")
            }
            Text(trip.accomName!)
            
            NavigationLink(destination: MapView(region: region, accom: accom, currTrip: trip)){
                    Map(coordinateRegion: $region , showsUserLocation: true, annotationItems: accom) { place in
                        MapMarker(coordinate: place.coordinate, tint: Color.purple)
                    }.frame(width: 400, height: 300).onAppear{
                        self.mapInitiate()
                    }
            }.onAppear{
                self.getSafetyRating(trip: trip)
                self.getCovidRestrictions(country: trip.destination!)
                self.mapInitiate()
                self.filterFavourite()
            }
            if !safetyRatings.isEmpty {
                HStack{
                    Text("\(safetyRatings.first!.name) Safety Ratings").onAppear{
                    self.mapSafetyScore()
                    }
                    Spacer()
                    if !showSafety {
                        Image(systemName: "plus.circle").onTapGesture{
                        self.showSafety.toggle()
                        }
                    }else{
                        Image(systemName: "minus.circle").onTapGesture{
                        self.showSafety.toggle()
                        }
                    }
                    
                }
                if showSafety{
                    List{
                        HStack{
                            Text("Overall")
                            Spacer()
                            Text(self.overall)
                        }
                        HStack{
                            Text("Theft")
                            Spacer()
                            Text(self.theft)
                        }
                        HStack{
                            Text("Physical Harm")
                            Spacer()
                            Text(self.physicalHarm)
                        }
                        HStack{
                            Text("Women")
                            Spacer()
                            Text(self.women)
                        }
                        HStack{
                            Text("LGBTQ")
                            Spacer()
                            Text(self.lgbt)
                        }
                    }.frame(height: 250)
                        // add animation
                }
            }
            if covidAvailable{
                
                NavigationLink(destination: CovidDataView(covidResults: self.covidResults!)){
                    HStack{
                        Text("Covid Restrictions and Information")
                        Spacer()
                    
                    }
                }
            }
                    
            Section{
                Text("Starred Places")
        
                List {
                    ForEach(Array(filteredFavs), id:\.self) { item in
                        NavigationLink(destination: MapView(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), latitudinalMeters: 1000.0, longitudinalMeters: 1000.0), accom: accom, currTrip: trip)){
                            VStack{
                                HStack{
                                    Text(item.name ?? "Unknown")
                                    Spacer()
                                    Image(systemName: "star.fill").onTapGesture{
                                        PersistenceController.shared.delete(item)
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
        }
    }
}


struct SafetyRating {
    var safetyScores = SafetyScore()
    var name = ""
}

struct SafetyScore{
    var lgbtq = 0
    var theft = 0
    var physicalHarm = 0
    var women = 0
    var overall = 0
}

