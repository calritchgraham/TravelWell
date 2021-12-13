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
    
    func checkNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.addNotifications()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func addNotifications() {
        let notification1 = UNMutableNotificationContent()
        notification1.title = "Jet Lag Advice"
        notification1.subtitle = "Go to bed 2/3 hours \(jetLagAdvice!.modifierPre) than normal"
        notification1.sound = UNNotificationSound.default
        
        let notification2 = UNMutableNotificationContent()
        notification2.title = "Jet Lag Advice"
        notification2.subtitle = "Go to bed 1/2 hours \(jetLagAdvice?.modifierPre) than normal"
        notification2.sound = UNNotificationSound.default
        
        let date1 = twoDaysBefore.advanced(by: 20 * 60 * 60) //advance by 20 hours to start at 8pm
        let date2 = oneDayBefore.advanced(by: 20 * 60 * 60)
        
        let dateComponent1 = Calendar.current.dateComponents([.year, .month, .day], from: date1)
        let dateComponent2 = Calendar.current.dateComponents([.year, .month, .day], from: date2)
        
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateComponent1, repeats: false)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponent2, repeats: false)
      
        let request1 = UNNotificationRequest(identifier: UUID().uuidString, content: notification1, trigger: trigger1)
        let request2 = UNNotificationRequest(identifier: UUID().uuidString, content: notification2, trigger: trigger2)
        
        UNUserNotificationCenter.current().add(request1)
        UNUserNotificationCenter.current().add(request2)
    }
    
//    func checkCalendarAccess() {
//        let eventStore = EKEventStore()
//
//        eventStore.requestAccess(to: .event, completion:
//              {(granted: Bool, error: Error?) -> Void in
//                  if granted {
//                    self.addEvents(store: eventStore)
//                  } else {
//                    print("Access denied")
//                  }
//            })
//        }
//
//    func addEvents(store: EKEventStore) {
//
//        let calendars = store.calendars(for: .reminder)
//        let calendar = calendars.first
//
//        print(calendars)
//
//        let event1 = EKEvent(eventStore: store)
//        event1.title = "Go to bed 2/3 hours \(jetLagAdvice!.modifierPre) than normal"
//        event1.startDate = twoDaysBefore.advanced(by: 19 * 60 * 60) //advance by 19 hours to start at 7pm
//        event1.endDate = twoDaysBefore.advanced(by: 19.5 * 60 * 60)
//        event1.calendar = calendar
//
//        let event2 = EKEvent(eventStore: store)
//        event2.title = "Go to bed 1/2 hours \(jetLagAdvice?.modifierPre) than normal"
//        event2.startDate = oneDayBefore.advanced(by: 20 * 60 * 60) //advance by 20 hours to start at 8pm
//        event2.endDate = oneDayBefore.advanced(by: 20.5 * 60 * 60)
//        event2.calendar = calendar
//
//        do {
//            try store.save(event1, span: .thisEvent)
//            try store.save(event2, span: .thisEvent)
//        }
//        catch let error {
//            print("Error adding to calendar: ", error)
//        }
//    }
}

