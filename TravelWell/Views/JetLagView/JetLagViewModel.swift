//
//  JetLagViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import CoreData
import SwiftUI
import EventKit
import EventKitUI

final class JetLagViewModel : ObservableObject {
    var trip : Trip?
    private var profile : AppProfile?
    var managedObjectContext = PersistenceController.shared.container.viewContext
    @Published var easternTravel = false
    @Published var diffInSeconds = 0
    let oneDayInSecs : Double = -60 * 60 * 24
    let oneHourInSecs : Double = -60 * 60
    @Published var oneDayBefore = Date()
    @Published var twoDaysBefore = Date()
    @Published var dayAfter = Date()
    @Published var today = Date()
    @Published var jetLagAdvice : JetLagAdvice?
    
    func setProfile(profile: AppProfile){
        self.profile = profile
    }
    
    func setTrip(trip: Trip){
        self.trip = trip
    }
    
    func retrieveProfile(){
        let fetchRequestProfile: NSFetchRequest<AppProfile>
        fetchRequestProfile = AppProfile.fetchRequest()
        profile = try! managedObjectContext.fetch(fetchRequestProfile).first
    }
        
    func calcTimeDiff(){            //back to back trips?
        if profile != nil{
            let homeTZ = TimeZone(identifier: (profile?.timeZone)!)
            let tripTZ = TimeZone(identifier: (trip?.timeZone)!)
            diffInSeconds = tripTZ!.secondsFromGMT() - homeTZ!.secondsFromGMT()
            oneDayBefore = (trip?.outbound?.advanced(by: oneDayInSecs))!
            twoDaysBefore = (trip?.outbound?.advanced(by: oneDayInSecs).advanced(by: oneDayInSecs))!
        }
        
        if (diffInSeconds > 0){
            easternTravel = true
            diffInSeconds = abs(diffInSeconds)
        }
        print(easternTravel)
        jetLagAdvice = JetLagAdvice(easternTravel: easternTravel)
    }
    
    func checkCalendarAccess() {
        let eventStore = EKEventStore()
                
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            self.addEvents(store: eventStore)
            case .denied:
                print("Access denied")
            case .notDetermined:
            
                eventStore.requestAccess(to: .event, completion:
                  {[weak self] (granted: Bool, error: Error?) -> Void in
                      if granted {
                          print("approoved")
                          self?.addEvents(store: eventStore)
                      } else {
                            print("Access denied")
                      }
                })
                default:
                    print("Case default")
        }
    }
    
    func addEvents(store: EKEventStore) {
        
        let calendars = store.calendars(for: .event)
        
        let event1 = EKEvent(eventStore: store)
        event1.title = "Go to bed 2/3 hours \(jetLagAdvice!.modifierPre) than normal"
        event1.startDate = twoDaysBefore.advanced(by: 19 * 60 * 60) //advance by 19 hours to start at 7pm
        event1.endDate = twoDaysBefore.advanced(by: 19.5 * 60 * 60)
  
        let event2 = EKEvent(eventStore: store)
        event2.title = "Go to bed 1/2 hours \(jetLagAdvice?.modifierPre) than normal"
        event2.startDate = oneDayBefore.advanced(by: 20 * 60 * 60) //advance by 20 hours to start at 8pm
        event2.endDate = oneDayBefore.advanced(by: 20.5 * 60 * 60)
        
        do {
            try store.save(event1, span: .thisEvent)
            try store.save(event2, span: .thisEvent)
        }
        catch {
           print("Error saving event in calendar")
        }
    }
}

