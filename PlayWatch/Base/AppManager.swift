//
//  AppManager.swift
//  PlayWatch
//
//  Created by David on 15/8/24.
//


import SwiftUI
import Observation

enum AppServer: String, CaseIterable, Identifiable {
    case openAI = "OpenAI"
    case gemini = "Gemini"
    
    var id: Self { self }
}

@Observable
final class AppManager {
    
    @ObservationIgnored
    @AppStorage("com.playwatch.storedAppServer")
    private var storedAppServer: AppServer = AppServer.openAI

    @ObservationIgnored
    @AppStorage("com.playwatch.storedAppLanguage")
    private var storedAppLanguage: AppLanguage = AppLanguage.system

    @ObservationIgnored
    @AppStorage("com.playwatch.storedAppRegion")
    private var storedAppRegion: AppRegion = AppRegion.system
    
    @ObservationIgnored
    var appServer: AppServer {
        get {
            access(keyPath: \.appServer)
            return self.storedAppServer
        }
        set {
            withMutation(keyPath: \.appServer) {
                self.storedAppServer = newValue
            }
        }
    }
    
    @ObservationIgnored
    var appLanguage: AppLanguage {
        get {
            access(keyPath: \.appLanguage)
            return self.storedAppLanguage
        }
        set {
            withMutation(keyPath: \.appLanguage) {
                self.storedAppLanguage = newValue
            }
        }
    }

    @ObservationIgnored
    var appRegion: AppRegion {
        get {
            access(keyPath: \.appRegion)
            return self.storedAppRegion
        }
        set {
            withMutation(keyPath: \.appRegion) {
                self.storedAppRegion = newValue
            }
        }
    }
    
    var appLocale: Locale {
        Locale(identifier: "\(self.appLanguage.languageCode)-\(self.appRegion.regionCode)")
    }
    
    var locale: MovieDB.Locale {
        MovieDB.Locale(name: self.appLanguage.name,
                       code: self.appLanguage.languageCode,
                       region: self.appRegion.regionCode)
    }
}
