//
//  JetLagView.swift
//  TravelWell
//
//  Created by Callum Graham on 18/11/2021.
//

import SwiftUI

struct JetLagView: View {
    
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    @State var trip : Trip?
    @State var easternTravel = false
    @State var diffInSeconds = 0
    let oneDayInSecs : Double = -60 * 60 * 24
    let oneHourInSecs : Double = -60 * 60
    @State var oneDayBefore = Date()
    @State var twoDaysBefore = Date()
    @State var dayAfter = Date()
    @State var today = Date()
    
    func calcTimeDiff(){            //back to back trips?
        if !profile.isEmpty{
            let homeTZ = TimeZone(identifier: (profile.first?.timeZone)!)
            let tripTZ = TimeZone(identifier: (trip?.timeZone)!)
            diffInSeconds = tripTZ!.secondsFromGMT() - homeTZ!.secondsFromGMT()
            oneDayBefore = (trip?.outbound?.advanced(by: oneDayInSecs))!
            twoDaysBefore = (trip?.outbound?.advanced(by: -oneDayInSecs).advanced(by: -oneDayInSecs))!
            dayAfter = (trip?.outbound?.advanced(by: abs(oneDayInSecs)))!
        }
        
        if (diffInSeconds < 0){
            easternTravel = true
            diffInSeconds = abs(diffInSeconds)
        }
        

    }
    
    var body: some View {
        VStack{
            if diffInSeconds == 0{
                Text("There is no time difference between your home and destination")
            }else{
                Text("The time difference between your home and destination is \(diffInSeconds/60/60) hours")
            
                
            }
           
                // if today == two days before show today, if today == ondeday before show nothing
                    //if eastern - earlier
                // if oneday == today show today, if today == outbound show nothing
                    //if eastern - earlier, arrive hydrated, avoid alcohol and caffeine during travel
                // if today == outbound show today otherwise show trip.outbound
                    //if eastern, exposire to bright light in the morning, take a 20-30min nap on arrival
                // if dayAfter == today show today
                    //if eastern, exposure to light in the morning
                
            Text("This advice is based on research by Dr Robert L Slack, published in The New England Journal of Medicine")
      
            
        }.onAppear{
            self.calcTimeDiff()
        }
        
    }
}



