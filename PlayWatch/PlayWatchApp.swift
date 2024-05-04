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
    
    @State private var languageManager = LanguageManager()
    
    var body: some Scene {
        WindowGroup {
            TabBarView(languageManager: languageManager)
                .environment(\.locale, Locale(identifier: languageManager.currentLanguageCode == AppLanguage.system.rawValue ? Locale.current.language.languageCode?.identifier ?? AppLanguage.english.rawValue : languageManager.currentLanguageCode))
        }
    }
}
