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
    
    @State private var appService = AppService.production
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                TabBarView()
                    .environment(\.locale, appService.settingsModelLogic.appLocale)
                    .environment(\.screenSize, geometry.size)
                    .environment(appService)
            }
        }
    }
}
