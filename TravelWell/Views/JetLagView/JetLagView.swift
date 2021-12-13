//
//  JetLagView.swift
//  TravelWell
//
//  Created by Callum Graham on 18/11/2021.
//

import SwiftUI

struct JetLagView: View {
    @State var trip : Trip?
    @State var isLoading = true
    @StateObject var jetLagViewModel = JetLagViewModel()
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    
    
    
    
    var body: some View {
        NavigationView{
            if isLoading {
                Text("Loading...").onAppear{
                    jetLagViewModel.retrieveProfile()
                    jetLagViewModel.setTrip(trip: trip!)
                    jetLagViewModel.calcTimeDiff()
                    self.isLoading = false
                }
            }else {
                VStack{
                    Form{
                        Section{
                            Button("Add Notification Reminders"){
                                //jetLagViewModel.checkCalendarAccess()
                                jetLagViewModel.checkNotificationAccess()
                            }
                        }
                        Section{
                            Text(jetLagViewModel.twoDaysBefore, style: .date).bold()
                            Text(jetLagViewModel.jetLagAdvice!.twoDaysBefore)
                        }
                    
                        Section{
                            Text(jetLagViewModel.oneDayBefore, style: .date).bold()
                            Text(jetLagViewModel.jetLagAdvice!.oneDayBefore)
                        }
                        Section{
                            Text((trip?.outbound)!, style: .date).bold()
                            Text(jetLagViewModel.jetLagAdvice!.arrival)
                        }
                        Section{
                            Text("This advice is based on research by Dr Robert L Slack, published in The New England Journal of Medicine, 2010")
                        }
                    }
                }
            }
        }.navigationBarHidden(true)
    }
}




