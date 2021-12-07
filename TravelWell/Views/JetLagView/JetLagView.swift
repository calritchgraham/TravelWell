//
//  JetLagView.swift
//  TravelWell
//
//  Created by Callum Graham on 18/11/2021.
//

import SwiftUI

struct JetLagView: View {
    @State var trip : Trip?
    @StateObject var jetLagViewModel = JetLagViewModel()
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    
    
    
    
    var body: some View {
        VStack{
            if jetLagViewModel.diffInSeconds < 7200 {  //2 hours
                Text("There is negligible time difference between your home and destination")
                
            }else{
                VStack{
                    Text((trip?.outbound)!, style: .date)
                    Text(jetLagViewModel.jetLagAdvice!.arrival)
                    
                }
                Text("This advice is based on research by Dr Robert L Slack, published in The New England Journal of Medicine, 2010")
                
            }
        }.onAppear{
            jetLagViewModel.setPersistentData(profile: profile)
            jetLagViewModel.setTrip(trip: trip!)
            jetLagViewModel.calcTimeDiff()
            
        }
    }
}



