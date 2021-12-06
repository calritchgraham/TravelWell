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
    @Published var name = ""
    @Published var selectedTZ = ""
    @Published var knownTimeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    @Published var hasPD = false
    @Published var localCurr = ""
    @Published var perDiem = ""
    var isoCurrencyCodes = Locale.commonISOCurrencyCodes
    
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    func retrieveProfile(){
        if self.profile.isEmpty{
            return
        }else{              //should be possible to unwrap as not saved unless complete and not executed if blank??
            self.name = profile.first!.name!
            self.selectedTZ = profile.first!.timeZone!
            self.perDiem = String(profile.first!.perDiem)
            self.localCurr = profile.first!.localCurr
            self.hasPD = profile.first!.hasPD
            //PersistenceController.shared.delete(profile.first!)
        }
    }
    
    
    func saveProfile(){
        let profile = AppProfile(context: managedObjectContext)
        profile.name = name
        profile.timeZone = selectedTZ
        profile.localCurr = localCurr
        profile.hasPD = hasPD
        profile.perDiem = Double(perDiem) ?? 0.0
        PersistenceController.shared.save()
    
    }
}
