import SwiftUI
import MapKit

struct MapSearchView: View {
    @StateObject var mapSearchViewModel = MapSearchViewModel()
    var searchTerm : String
    var accom  : [Location]
    var region : MKCoordinateRegion
    var currTrip : Trip
    
    var body: some View {
            VStack{
                List {
                    ForEach(mapSearchViewModel.results, id:\.self) { item in
                        NavigationLink(destination: MapView(region: MKCoordinateRegion(center: item.placemark.coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0), accom: accom, currTrip: currTrip)){
                            HStack{
                                Text(item.name ?? "Unknown")
                                Spacer()
                                if mapSearchViewModel.favourites.isEmpty {
                                    Image(systemName: "star").onTapGesture{
                                        mapSearchViewModel.favouriteSave(item: item)
                                    }
                                } else if mapSearchViewModel.favourites.contains(item.name!){
                                    Image(systemName: "star.fill").onTapGesture{
                                        mapSearchViewModel.deleteFavourite(name: item.name!)
                                    }
                                } else {
                                    Image(systemName: "star").onTapGesture{
                                        mapSearchViewModel.favouriteSave(item: item)
                                    }
                                }
                        }
                            }.onAppear{
                                mapSearchViewModel.populateFavourites()
                            }.onDisappear{ //not working
                                mapSearchViewModel.accom?.append(Location(coordinate: item.placemark.coordinate))
                }
                }
            }
               

            }.onAppear{
                mapSearchViewModel.setIVariables(searchTerm: searchTerm, accom: accom, region: region, currTrip: currTrip)
                mapSearchViewModel.search()
            }
    }
}
                                        
