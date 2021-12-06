//
//  ResultViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import MapKit
import SwiftUI
import CoreData

final class ResultViewModel : ObservableObject {
    var managedObjectContext = PersistenceController.shared.container.viewContext
    @Published var outbound = Date()
    @Published var inbound = Date()
    @Published var locationResults : [MKLocalSearchCompletion] = []
    @Published var searchTerm = ""
    

    func getOutboundRange() -> ClosedRange<Date> {
        let outboundRange: ClosedRange<Date> = {
            let calendar = Calendar.current
            let today = Date()
            let nextYear = today.advanced(by: 365 * 24 * 60 * 60)       //advance 1 year in seconds
            let startComponents = calendar.dateComponents([.year, .month, .day], from: today)
            let endComponents = calendar.dateComponents([(.year), .month, .day], from: nextYear)
            return calendar.date(from:startComponents)!
                ...
                calendar.date(from:endComponents)!
        }()
        return outboundRange
    }
    
    func getInboundRange() -> ClosedRange<Date> {
        let inboundRange: ClosedRange<Date> = {
            let calendar = Calendar.current
            let today = Date()
            let nextYear = today.advanced(by: 365 * 24 * 60 * 60)       //advance 1 year in seconds
            let startComponents = calendar.dateComponents([.year, .month, .day], from: outbound)
            let endComponents = calendar.dateComponents([(.year), .month, .day], from: nextYear)
                return calendar.date(from:startComponents)!
                    ...
                    calendar.date(from:endComponents)!
        }()
        return inboundRange
    }
    
    func addTrip(locationResult: MKLocalSearchCompletion){                               
        let trip = Trip(context: managedObjectContext)
        trip.inbound = inbound
        trip.outbound = outbound
        trip.accomName = locationResult.title
        trip.accomAddress = locationResult.subtitle
        //mapSearch.coordsFromLocation(location: locationResult, trip: trip)
        let request = MKLocalSearch.Request(completion: locationResult)
        let search = MKLocalSearch(request: request)
        Task {
          let response = try await search.start()
            if !response.mapItems.isEmpty{
                trip.timeZone = response.mapItems.first?.timeZone?.identifier
                trip.lat = (response.mapItems.first?.placemark.coordinate.latitude)!
                trip.long = (response.mapItems.first?.placemark.coordinate.longitude)!
                trip.destination = response.mapItems.first?.placemark.isoCountryCode
                PersistenceController.shared.save()
                try managedObjectContext.save()
            }else{
                //notify error
            }
        }
        
    }
}
