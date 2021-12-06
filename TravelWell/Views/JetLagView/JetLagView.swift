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
            if jetLagViewModel.diffInSeconds == 0{  //check timezones in paper 5??
                Text("There is no time difference between your home and destination")
            }else{
                Text("The time difference between your home and destination is \(jetLagViewModel.diffInSeconds/60/60) hours")
                
                if jetLagViewModel.today < jetLagViewModel.twoDaysBefore{
                    if jetLagViewModel.easternTravel{
                        //Text("\(trip?.outbound) : blah blah blah")  //show date and month - 2/3 hours earlier to bed
                        // outbound - 1 and outbound -2
                    } else {
                        //Text("\(trip?.outbound) : blah blah blah")  //show date and month
                        // outbound - 1 and outbound -2
                    }
                    
                }else if jetLagViewModel.today == jetLagViewModel.twoDaysBefore{
                    if jetLagViewModel.easternTravel{
                        Text("Today : Blah blah blah")
                        Text("Tomorrow : Blah blah blah")
                    } else {
                        //Text("\(trip?.outbound) : blah blah blah")  //show date and month
                    }
                } else if jetLagViewModel.today == jetLagViewModel.oneDayBefore{
                    if jetLagViewModel.easternTravel{
                        // today
                    }else {
                        //today
                    }
                }
                
                if jetLagViewModel.today > (trip?.outbound)!{
                    if jetLagViewModel.easternTravel{
                        // on day of arrival earlier, arrive hydrated, avoid alcohol and caffeine during travel
                        // exposure to bright light in the morning and 20-30min nap on arrival
                    } else  {
                        // today - blah blah blah
                    }
                } else if (trip?.outbound)! == jetLagViewModel.today{
                    if jetLagViewModel.easternTravel{
                        //today blah blah blah
                    } else {
                        //today blah blah blah
                    }
                }
                
                if jetLagViewModel.today < jetLagViewModel.dayAfter {
                    if jetLagViewModel.easternTravel{
                        //if eastern, exposure to light in the morning
                    } else {
                        //if eastern, exposure to light in the morning
                    }
                }else if jetLagViewModel.today == jetLagViewModel.dayAfter {
                    if jetLagViewModel.easternTravel{
                        //if eastern, exposure to light in the morning
                    } else {
                        
                    }
                }
          
                
                
                
            }
            // grey out after event??
           // same for inbound
                
            Text("This advice is based on research by Dr Robert L Slack, published in The New England Journal of Medicine")
      
            
        }.onAppear{
            jetLagViewModel.setPersistentData(profile: profile)
            jetLagViewModel.calcTimeDiff()
            jetLagViewModel.setTrip(trip: trip!)
        }
        
    }
}



