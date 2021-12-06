import SwiftUI
import MapKit

struct MapSearchView: View {
    @State var searchTerm : String
    @State var region : MKCoordinateRegion
    @State var results = [MKMapItem]()
    @State var accom  : [Location]
    @State var favourites = [String]()
    @State var currTrip : Trip
    @Environment(\.managedObjectContext) var managedObjectContext
   
    func search(){
        let request = MKLocalSearch.Request()
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
              for item in response!.mapItems {  //do something if nil
                  
                  results.append(item)
              }
            
        })
    }
    
    func populateFavourites() {
        for fav in Array(currTrip.favourite as! Set<Favourite>){
            favourites.append(fav.name!)
        }
    }
    
    func deleteFavourite(name : String) {
        for fav in Array(currTrip.favourite as! Set<Favourite>){
            if fav.name == name {
                PersistenceController.shared.delete(fav)
                for i in 0...favourites.count-1{
                    if favourites[i] == name {
                        favourites.remove(at: i)
                    }                }
    
                print(favourites)
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
        print(favourites)
    }
    var body: some View {
            VStack{
                List {
                    ForEach(results, id:\.self) { item in
                        NavigationLink(destination: MapView(region: MKCoordinateRegion(center: item.placemark.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0), accom: accom, currTrip: currTrip)){
                            HStack{
                                Text(item.name ?? "Unknown")
                                Spacer()
                                if favourites.isEmpty {
                                    Image(systemName: "star").onTapGesture{
                                        self.favouriteSave(item: item)
                                    }
                                } else if favourites.contains(item.name!){
                                    Image(systemName: "star.fill").onTapGesture{
                                        deleteFavourite(name: item.name!)
                                    }
                                } else {
                                    Image(systemName: "star").onTapGesture{
                                        self.favouriteSave(item: item)
                                    }
                                }
                        }
                            }.onAppear{
                                self.populateFavourites()
                                print(favourites)
                            }.onDisappear{ //not working
                        accom.append(Location(coordinate: item.placemark.coordinate))
                }
                }
            }
               

            }.onAppear{
                self.search()
            }
    }
}
                                        
