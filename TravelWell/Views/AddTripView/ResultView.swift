//
//  ResultView.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//



import SwiftUI
import MapKit

struct ResultView : View {
    @StateObject private var resultViewModel = ResultViewModel()
    var locationResult : MKLocalSearchCompletion
    
    var body: some View {
        NavigationView{
            VStack {
                Form{
                    Section{
                        Text(locationResult.title).bold().padding()
                        Text(locationResult.subtitle).padding()
                    }
                    Section{
                        DatePicker("Outbound Date", selection: $resultViewModel.outbound, in: resultViewModel.getOutboundRange(), displayedComponents: .date)

                        DatePicker("Inbound Date", selection: $resultViewModel.inbound, in: resultViewModel.getInboundRange(), displayedComponents: .date)
                    }
                }
                
                NavigationLink(destination: TripsView().navigationBarHidden(true)) {
                    Text("Add Trip")
                }.simultaneousGesture(TapGesture().onEnded{
                    resultViewModel.addTrip(locationResult: locationResult)
                })
                }.navigationBarTitle("Select Dates", displayMode: .inline)
        }
        }
    }

   
    


