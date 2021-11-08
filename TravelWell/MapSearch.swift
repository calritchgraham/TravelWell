//
//  MapSearch.swift
//  diss
//
//  Created by Callum Graham on 04/11/2021.
//

import Foundation
import MapKit
import Combine
import CoreLocation
import CoreData

class MapSearch : NSObject, ObservableObject {
    @Published var locationResults : [MKLocalSearchCompletion] = []
    @Published var searchTerm = ""
    private var cancellables : Set<AnyCancellable> = []
    private var searchCompleter = MKLocalSearchCompleter()
    private var currentPromise : ((Result<[MKLocalSearchCompletion], Error>) -> Void)?
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap({ (currentSearchTerm) in
                self.searchTermToResults(searchTerm: currentSearchTerm)
            })
            .sink(receiveCompletion: { (completion) in
                //handle error
            }, receiveValue: { (results) in
                self.locationResults = results
            })
            .store(in: &cancellables)
    }
    
    func coordsFromLocation(location: MKLocalSearchCompletion, trip: Trip)  {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location.title + " " + location.subtitle) {
                placemarks, error in
                let placemark = placemarks?.first
                trip.lat = (placemark?.location?.coordinate.latitude)! //handle error here of not found
                trip.long = (placemark?.location?.coordinate.longitude)!
                trip.destination = placemark?.isoCountryCode
                print(trip.destination ?? "not foiund")
                PersistenceController.shared.save()
            }
        }
    

    
    
    func searchTermToResults(searchTerm: String) -> Future<[MKLocalSearchCompletion], Error> {
        Future { promise in
            self.searchCompleter.queryFragment = searchTerm
            self.currentPromise = promise
        }
    }
}
    


extension MapSearch : MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            currentPromise?(.success(completer.results))
        }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        //could deal with the error here, but beware that it will finish the Combine publisher stream
        //currentPromise?(.failure(error))
    }
}
