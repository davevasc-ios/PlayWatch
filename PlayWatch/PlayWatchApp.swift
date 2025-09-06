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
    
    @State private var appViewModel: AppViewModel = AppViewModel.production
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                TabBarView()
                    .environment(\.locale, appViewModel.settingsModelLogic.appLocale)
                    .environment(\.screenSize, geometry.size)
                    .environment(appViewModel)
            }
        }
    }
}
