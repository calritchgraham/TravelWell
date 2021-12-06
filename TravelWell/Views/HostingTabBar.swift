     //
//  HostingTabBar.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//

import SwiftUI

struct HostingTabBar: View {
    private enum Tab: Hashable {
            case home
            case trips
            case profile
        }
        
        @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "house.fill")
                }
            TripsView()
                .tag(1)
                .tabItem {
                    Image(systemName: "airplane")
                }
            ProfileView()
                .tag(2)
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}
