import Foundation
import SwiftUI
import MapKit
import CoreData



struct AddTripView: View{
    @StateObject var addTripViewModel = AddTripViewModel()
    
    var body: some View{
        NavigationView{
            VStack{
                Form {
                    Section {
                        TextField("Address", text: $addTripViewModel.searchTerm)
                    }
                    Section {
                        ForEach(addTripViewModel.locationResults, id: \.self) { location in
                            NavigationLink(destination: ResultView(locationResult: location)) {
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
}

