//
//  PlayWatchApp.swift
//  PlayWatch
//
//  Created by David on 17/3/24.
//

import SwiftUI
import SwiftData

@main
struct PlayWatchApp: App {
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
    
    @State private var localeManager = LocaleManager()
    @State private var serverManager = ServerManager()
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                TabBarView(localeManager: localeManager, serverManager: serverManager)
                    .environment(\.locale, localeManager.appLocale)
                    .environment(\.screenSize, geometry.size)
            }
        }
    }
}
