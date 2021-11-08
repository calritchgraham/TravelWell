//
//  TravelWellApp.swift
//  TravelWell
//
//  Created by Callum Graham on 08/11/2021.
//

import SwiftUI

@main
struct TravelWellApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HostingTabBar()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
