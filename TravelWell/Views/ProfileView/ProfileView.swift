//
//  ProfileView.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//

import SwiftUI
import CoreData
import UIKit


struct ProfileView: View {
     
    @StateObject private var profileViewModel = ProfileViewModel()

    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: AppProfile.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \AppProfile.timeZone, ascending: true)]
                        ) var profile: FetchedResults<AppProfile>
    
    var body: some View {
        NavigationView{
                ScrollView{
                VStack(){
                    Form {
                        TextField("Name", text: $profileViewModel.name)
                    }.frame(height: 50.0)
                
                    Form {
                        Picker("Home Time Zone", selection: $profileViewModel.selectedTZ) {
                            ForEach(profileViewModel.knownTimeZoneIdentifiers, id: \.self) {
                              Text($0)
                          }

                      }
                    }.frame(height: 100.0)
                       
                    Form {
                        Picker("Local Currency", selection: $profileViewModel.localCurr) {
                            ForEach(profileViewModel.isoCurrencyCodes, id: \.self) {
                              Text($0)
                          }
                      }
                    }.frame(height: 100.0)
                    
                    Toggle("Do you have a per diem?", isOn: $profileViewModel.hasPD)
                    
                    if profileViewModel.hasPD{
                        Form {
                            TextField("Per Diem Amount", text: $profileViewModel.perDiem)
                        }.keyboardType(.decimalPad)
                        .frame(height: 50.0)
                    }
                    
                    if profileViewModel.perDiem != ""{
                        Button("Save"){
                            hideKeyboard()
                            profileViewModel.saveProfile()
                        }
                    }
                  
                }.onAppear{
                    profileViewModel.retrieveProfile()
                }
            }
        }
    }
    
    
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

