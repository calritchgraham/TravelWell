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
            if diffInSeconds == 0{  //check timezones in paper 5??
                Text("There is no time difference between your home and destination")
            }else{
                Text("The time difference between your home and destination is \(diffInSeconds/60/60) hours")
                
                if today < twoDaysBefore{
                    if easternTravel{
                        //Text("\(trip?.outbound) : blah blah blah")  //show date and month - 2/3 hours earlier to bed
                        // outbound - 1 and outbound -2
                    } else {
                        //Text("\(trip?.outbound) : blah blah blah")  //show date and month
                        // outbound - 1 and outbound -2
                    }
                    
                }else if today == twoDaysBefore{
                    if easternTravel{
                        Text("Today : Blah blah blah")
                        Text("Tomorrow : Blah blah blah")
                    } else {
                        //Text("\(trip?.outbound) : blah blah blah")  //show date and month
                    }
                } else if today == oneDayBefore{
                    if easternTravel{
                        // today
                    }else {
                        //today
                    }
                }
                
                if today > (trip?.outbound)!{
                    if easternTravel{
                        // on day of arrival earlier, arrive hydrated, avoid alcohol and caffeine during travel
                        // exposure to bright light in the morning and 20-30min nap on arrival
                    } else  {
                        // today - blah blah blah
                    }
                } else if (trip?.outbound)! == today{
                    if easternTravel{
                        //today blah blah blah
                    } else {
                        //today blah blah blah
                    }
                }
                
                if today < dayAfter {
                    if easternTravel{
                        //if eastern, exposure to light in the morning
                    } else {
                        //if eastern, exposure to light in the morning
                    }
                }else if today == dayAfter {
                    if easternTravel{
                        //if eastern, exposure to light in the morning
                    } else {
                        
                    }
                }
          
                
                
                
            }
            // grey out after event??
           // same for inbound
                
            Text("This advice is based on research by Dr Robert L Slack, published in The New England Journal of Medicine")
      
            
        }.onAppear{
            self.calcTimeDiff()
        }
        
    }
}



