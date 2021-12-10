//
//  ProfileViewModel.swift
//  TravelWell
//
//  Created by Callum Graham on 06/12/2021.
//

import Foundation
import CoreData
import SwiftUI


final class ProfileViewModel : ObservableObject{
    var managedObjectContext = PersistenceController.shared.container.viewContext
    @Published var selectedTZ = ""
    @Published var knownTimeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    @Published var hasPD = false
    @Published var localCurr = ""
    @Published var perDiem = ""
    var isoCurrencyCodes = Locale.commonISOCurrencyCodes
    @Published var profile : AppProfile?
    
    func retrieveProfile(){
        let fetchRequestProfile: NSFetchRequest<AppProfile>
        fetchRequestProfile = AppProfile.fetchRequest()
        profile = try! managedObjectContext.fetch(fetchRequestProfile).first
        
        if profile != nil {
            self.selectedTZ = (profile?.timeZone!)!
            self.perDiem = String((profile?.perDiem)!)
            self.localCurr = profile!.localCurr
            self.hasPD = ((profile?.hasPD)!)
        }
    }
    
    
    func saveProfile(){
        let profile = AppProfile(context: managedObjectContext)
        profile.timeZone = self.selectedTZ
        profile.localCurr = self.localCurr
        profile.hasPD = self.hasPD
        profile.perDiem = Double(self.perDiem) ?? 0.0
        PersistenceController.shared.save()
    
    }
}
