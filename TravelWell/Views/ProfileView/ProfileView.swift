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

    var body: some View {
        NavigationView{
            VStack{
                Form{
                    Picker("Home Time Zone", selection: $profileViewModel.selectedTZ) {
                        ForEach(profileViewModel.knownTimeZoneIdentifiers, id: \.self) {
                          Text($0)
                        }
                    }
                    
                    Picker("Local Currency", selection: $profileViewModel.localCurr) {
                        ForEach(profileViewModel.isoCurrencyCodes, id: \.self) {
                          Text($0)
                        }
                    }
                    Toggle("Do you have a per diem?", isOn: $profileViewModel.hasPD)
                    
                    if profileViewModel.hasPD{
                        TextField("Per Diem Amount", text: $profileViewModel.perDiem).keyboardType(.decimalPad)
                    }
                }
            }
        }.onTapGesture{
            hideKeyboard()
        }.onAppear{
            profileViewModel.retrieveProfile()
        }.onDisappear{
            profileViewModel.saveProfile()
        }
    }
}



