import SwiftUI
import MapKit

struct MapSearchView: View {
    @State var searchTerm : String
    @State var region : MKCoordinateRegion
    let request = MKLocalSearch.Request()
    @State var results = [MKMapItem]()
    @State var accom  : [Location]
    let geocoder = CLGeocoder()


    func search(){
        request.region = region
        request.naturalLanguageQuery = searchTerm
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
                   
           if error != nil {
              print("Error occured in search: \(error!.localizedDescription)")
           } else if response!.mapItems.count == 0 {
              print("No matches found")
           } else {
              print("Matches found")
           }
              for item in response!.mapItems {
                  
                  results.append(item)
              }
            
        })
    }
    var body: some View {
            VStack{
                List {
                    ForEach(results, id:\.self) { item in
                        NavigationLink(destination: MapView(region: MKCoordinateRegion(center: item.placemark.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0), accom: accom)){
                            HStack{
                                Text(item.name ?? "Unknown")
                                Text(item.phoneNumber ?? "Unknown")
                            }.onTapGesture{
                                accom.append(Location(coordinate: item.placemark.coordinate))
                            }
                        }
                    }
                }

            }.onAppear{
                self.search()
            }
    }
}
    
