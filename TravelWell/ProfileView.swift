//
//  ProfileView.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @State var name: String = ""
    @State private var selectedTZ = ""
    @State var knownTimeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    @State private var sunday = false
    @State private var monday = false
    @State private var tuesday = false
    @State private var wednesday = false
    @State private var thursday = false
    @State private var friday = false
    @State private var saturday = false
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var currTime = Date()
    @State private var showingAlert = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    var body: some View {
        NavigationView{
            VStack(){
                Form {
                    TextField("Name", text: $name)
                }.frame(height: 50.0)
                 
                    
                Form {
                  Picker("Home Time Zone", selection: $selectedTZ) {
                      ForEach(knownTimeZoneIdentifiers, id: \.self) {
                          Text($0)
                      }
                  }
                }.frame(height: 100.0)
                   
                Group{
                    Text("Please select the days of the week you work.")
                    Toggle("Sunday", isOn: $sunday)
                    Toggle("Monday", isOn: $monday)
                    Toggle("Tuesday", isOn: $tuesday)
                    Toggle("Wednesday", isOn: $wednesday)
                    Toggle("Thursday", isOn: $thursday)
                    Toggle("Friday", isOn: $friday)
                    Toggle("Saturday", isOn: $saturday)
                }
                DatePicker("Core Hours Start", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("Core Hours End", selection: $endTime, displayedComponents: .hourAndMinute)
                
                Spacer()
              
      
            }.onDisappear{
                if(name != "" && selectedTZ != "" && startTime != currTime && endTime != currTime){
                    self.saveProfile()
                }
            }.onAppear{
                self.retrieveProfile()
            }
        }
    }
    
    func retrieveProfile(){
        if self.profile.isEmpty{
            return
        }else{              //should be possible to unwrap as not saved unless complete and not executed if blank??
            self.name = profile.first!.name!
            self.selectedTZ = profile.first!.timeZone!
            self.sunday = profile.first!.sunday
            self.monday = profile.first!.monday
            self.tuesday = profile.first!.tuesday
            self.wednesday = profile.first!.wednesday
            self.thursday = profile.first!.thursday
            self.friday = profile.first!.friday
            self.saturday = profile.first!.saturday
            self.startTime = profile.first!.startTime!
            self.endTime = profile.first!.endTime!
            
            PersistenceController.shared.delete(profile.first!)
        }
    }
    
    
    func saveProfile(){
        let profile = AppProfile(context: managedObjectContext)
        profile.name = name
        profile.timeZone = selectedTZ
        profile.endTime = endTime
        profile.startTime = startTime
        
        if sunday{
            profile.sunday = true
        }
        if monday{
            profile.monday = true
        }
        if tuesday{
            profile.tuesday = true
        }
        if wednesday{
            profile.wednesday = true
        }
        if thursday{
            profile.thursday = true
        }
        if friday{
            profile.friday = true
        }
        if saturday{
            profile.saturday = true
        }
        
        PersistenceController.shared.save()
    
    }
}
