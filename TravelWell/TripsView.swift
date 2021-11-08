import SwiftUI
import CoreData

struct TripsView: View {
    
    @FetchRequest(entity: Trip.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Trip.outbound, ascending: true)]
                        ) var trips: FetchedResults<Trip>
    
    func removeTrip(at offsets: IndexSet){
        for index in offsets {
            let trip = trips[index]
            PersistenceController.shared.delete(trip)
        }
        
    }
    var body: some View {
        NavigationView{
            VStack{
                
                List {
                    ForEach(trips, id:\.self) { currentTrip in
                        NavigationLink(destination: TripView(trip: currentTrip)){
                            Text("\(currentTrip.accomName ?? "Unknown")")
                        }
                    }.onDelete(perform: removeTrip)
                }
                
                NavigationLink(destination: AddTripView()){
                  Text("Add a Trip")
                }
            }
        }
    }
        
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView()
    }
}
