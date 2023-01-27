//
//  CustomTabBarApp.swift
//  CustomTabBar
//
//  Created by Abdullah Karaboğa on 27.01.2023.
//

import SwiftUI

@main
struct CustomTabBarApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
