import SwiftUI
import MapKit

struct MapSearchView: View {
    @State var searchTerm : String
    @State var region : MKCoordinateRegion
    let request = MKLocalSearch.Request()
    @State var results = [MKMapItem]()
    @State var accom  : [Location]
    let geocoder = CLGeocoder()
    @State var currTrip : Trip
    @State var filteredFavs = Set<String>()
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Favourite.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Favourite.name, ascending: true)]
                  
                        ) var favourites: FetchedResults<Favourite>

    // fetch favourites, code remove favourite from button press and chahge start to fill if already favourited

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
    func favouriteFilter(){
        for item in favourites{
            if item.trip == currTrip{
                self.filteredFavs.insert(item.name!)
                //print(item.name)
            }
        }
    }
    
    func favouriteDelete(item: MKMapItem){
        for favourite in favourites{
            if favourite.name == item.name{
                let favouriteDelete = favourite
                managedObjectContext.delete(favouriteDelete)
                filteredFavs.remove(item.name!)
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
        filteredFavs.insert(item.name!)
    }
    var body: some View {
            VStack{
                List {
                    ForEach(results, id:\.self) { item in
                        NavigationLink(destination: MapView(region: MKCoordinateRegion(center: item.placemark.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0), accom: accom, currTrip: currTrip)){
                            HStack{
                                Text(item.name ?? "Unknown")
                                Spacer()
                                if filteredFavs.contains(item.name!){
                                    Image(systemName: "star.fill").onTapGesture{
                                        self.favouriteDelete(item: item)
                                        
                                    }
                                        
                                }else{
                                    Image(systemName: "star").onTapGesture{
                                        self.favouriteSave(item: item)
                                    }
                                }
                            }.onTapGesture{
                                accom.append(Location(coordinate: item.placemark.coordinate))
                            }
                        }
                    }
                }

            }.onAppear{
                self.search()
                self.favouriteFilter()
            }
    }
}
    
