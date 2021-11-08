import SwiftUI
import MapKit

struct MapSearchView: View {
    @State var searchTerm : String
    @State var region : MKCoordinateRegion
    let request = MKLocalSearch.Request()
    @State var results = [MKMapItem]()
    @State var accom  : [Location]


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
        NavigationView{
            VStack{
                
                List {
                    ForEach(results, id:\.self) { item in
                        //NavigationLink(destination: MapView(region: MKCoordinateRegion(center: item.coord, accom: accom)){
                            Text((String(describing: item.name)))
                        //}
                    }
                }.onAppear{
                    self.search()
                }
            }
        }
    }
}
