//
//  ResultView.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import Foundation
import MapKit
import SwiftUI
import Amadeus

struct ResultView : View {
    @StateObject private var resultViewModel = ResultViewModel()
    var locationResult : MKLocalSearchCompletion
    
    var body: some View {
        
        VStack{
            Text(locationResult.title).bold()
            Text(locationResult.subtitle)
            DatePicker("Outbound Date", selection: $resultViewModel.outbound, in: resultViewModel.getOutboundRange(), displayedComponents: .date)

            DatePicker("Inbound Date", selection: $resultViewModel.inbound, in: resultViewModel.getInboundRange(), displayedComponents: .date)
            
            
            
            NavigationLink(destination: TripsView().navigationBarHidden(true)) {
                Text("Add Trip")
            }.simultaneousGesture(TapGesture().onEnded{
                resultViewModel.addTrip(locationResult: locationResult)
            })
            
        }.navigationBarTitle("Select Dates", displayMode: .inline)
        
    }
}


