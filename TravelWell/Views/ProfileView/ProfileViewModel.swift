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
    lazy var managedObjectContext = PersistenceController.shared.container.viewContext
    @Published var selectedTZ = ""
    lazy var knownTimeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    @Published var hasPD = false
    @Published var localCurr = ""
    @Published var perDiem = ""
    lazy var isoCurrencyCodes = Locale.commonISOCurrencyCodes
    @Published var profile : AppProfile?
    
    func setProfile(profile: AppProfile){
        self.profile = profile
        self.setProfileValues()
    }
    
    func retrieveProfile(){
        let fetchRequestProfile: NSFetchRequest<AppProfile>
        fetchRequestProfile = AppProfile.fetchRequest()
        profile = try! managedObjectContext.fetch(fetchRequestProfile).first
        self.setProfileValues()
    }
    
    func setProfileValues() {       //display current values
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
        if self.hasPD {
            profile.perDiem = Double(self.perDiem) ?? 0.0
        } else {
            profile.perDiem = 0.0
        }
        PersistenceController.shared.save()
    
    }
}
