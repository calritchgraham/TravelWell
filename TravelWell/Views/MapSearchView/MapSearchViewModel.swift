//
//  MapSearch.swift
//  diss
//
//  Created by Callum Graham on 04/11/2021.
//

import Combine
import SwiftUI
import MapKit



class MapSearchViewModel: ObservableObject {
    @Published var searchTerm : String?
    @Published var region : MKCoordinateRegion?
    @Published var results = [MKMapItem]()
    @Published var accom  : [Location]?
    @Published var favourites = [String]()
    @Published var currTrip : Trip?
    var managedObjectContext = PersistenceController.shared.container.viewContext
    
    func setIVariables(searchTerm: String, accom: [Location], region: MKCoordinateRegion, currTrip: Trip){
        self.searchTerm = searchTerm
        self.accom = accom
        self.region = region
        self.currTrip = currTrip
    }

   
    func search(){          //search with search term
        let request = MKLocalSearch.Request()
        request.region = region!
        request.naturalLanguageQuery = searchTerm
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
                   
       if error != nil {
          print("Error occured in search: \(error!.localizedDescription)")
        }
        for item in response!.mapItems {
          self.results.append(item)
      }
        
    })
    }
    
    func populateFavourites() {  //add current favourites so this can be displayed in comparison to results
        for fav in Array(currTrip?.favourite as! Set<Favourite>){
            if fav.name != nil{
                favourites.append(fav.name!)
            }
        }
    }
    
    func deleteFavourite(name : String) {
        for fav in Array(currTrip?.favourite as! Set<Favourite>){
            if fav.name == name {
                PersistenceController.shared.delete(fav)
                for i in 0...(favourites.count - 1){
                    if favourites[i] == name {
                        favourites.remove(at: i)
                    }
                }
            }
        }
    }
    
    func favouriteSave(item: MKMapItem){
        let favourite = Favourite(context: managedObjectContext)
        favourite.trip = currTrip
        favourite.lat = (item.placemark.location?.coordinate.latitude)!
        favourite.long = (item.placemark.location?.coordinate.longitude)!
        favourite.name = item.placemark.name
        PersistenceController.shared.save()
        favourites.append(item.name!)
    }
    
}
