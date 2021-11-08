import Foundation
import SwiftUI
import MapKit
import CoreData



struct AddTripView: View{
    @StateObject var mapSearch = MapSearch()

    var body: some View{
        NavigationView{
            VStack{
                Form {
                                Section {
                                    TextField("Address", text: $mapSearch.searchTerm)
                                }
                                Section {
                                    ForEach(mapSearch.locationResults, id: \.self) { location in
                                        NavigationLink(destination: Result(locationResult: location)) {
                                            VStack(alignment: .leading) {
                                                Text(location.title)
                                                Text(location.subtitle)
                                                    .font(.system(.caption))
                                            }
                                        }
                                    }
                                }
                            }
            }
        }.navigationBarHidden(true)
    }
    
struct Result : View {
    @Environment(\.managedObjectContext) var managedObjectContext
    var locationResult : MKLocalSearchCompletion
    @State private var outbound = Date()
    @State private var inbound = Date()
    let mapSearch = MapSearch()
    
    func addTrip(){                                 // save trip
        let trip = Trip(context: managedObjectContext)
        trip.inbound = inbound
        trip.outbound = outbound
        trip.accomName = locationResult.title
        trip.accomAddress = locationResult.subtitle
        mapSearch.coordsFromLocation(location: locationResult, trip: trip)
    }
    
    let outboundRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        var today = Date()
        var nextYear = today.advanced(by: 365 * 24 * 60 * 60)       //advance 1 year in seconds
        
        let startComponents = calendar.dateComponents([.year, .month, .day], from: today)
        let endComponents = calendar.dateComponents([(.year), .month, .day], from: nextYear)
        
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
        }()
    
    var body: some View {
        
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
        
        VStack{
            Text(locationResult.title)
            Text(locationResult.subtitle)
            DatePicker("Outbound Date", selection: $outbound, in: outboundRange, displayedComponents: .date)
            DatePicker("Inbound Date", selection: $inbound, in: inboundRange, displayedComponents: .date)
            
            NavigationLink(destination: TripsView().navigationBarHidden(true)) {
                                    Text("Add Trip")
                                }.simultaneousGesture(TapGesture().onEnded{
                                    self.addTrip()
                            })
            
        }.navigationBarTitle("Select Dates", displayMode: .inline)
        
    }
    }
}

struct AddTripView_Previews: PreviewProvider {
    static var previews: some View {
        AddTripView()
    }
}
