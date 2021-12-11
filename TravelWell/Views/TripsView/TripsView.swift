import SwiftUI


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
                Form {
                    ForEach(trips, id:\.self) { currentTrip in
                        NavigationLink(destination: TripView(trip: currentTrip)){
                            VStack{
                                Text("\(currentTrip.accomName ?? "Unknown") , \(currentTrip.destination ?? "Unknown")").bold()
                                Text("\(currentTrip.outbound!, style: .date) to \(currentTrip.inbound!, style: .date)")
                            }
                            
                            
                        }
                    }.onDelete(perform: removeTrip)
                    Spacer()
                    Section{
                        NavigationLink(destination: AddTripView()){
                          Text("Add a Trip")
                        }
                    }
                }
            }
        }
    }
        
}

