//
//  MacOSApplicationApp.swift
//  MacOSApplication
//
//  Created by Vivek Patel on 14/03/24.
//

import SwiftUI
import SwiftData

@main
struct MacOSApplicationApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
