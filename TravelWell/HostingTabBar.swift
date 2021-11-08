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
            case explore
            case user
            case settings
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
//            MapView()
//                .tag(2)
//                .tabItem {
//                    Image(systemName: "map.fill")
//                }
            ProfileView()
                .tag(3)
                .tabItem {
                    Image(systemName: "person")
                }
        }
    }
}

struct HostingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        HostingTabBar()
    }
}
