//
//  AppManager.swift
//  PlayWatch
//
//  Created by David on 15/8/24.
//


import SwiftUI
import Observation

@Observable
final class AppManager {
    
    @ObservationIgnored
    @AppStorage("com.playwatch.storedAIServer")
    private var storedAIServer: AIServer = AIServer.openAI

    @ObservationIgnored
    @AppStorage("com.playwatch.storedAppLanguage")
    private var storedAppLanguage: AppLanguage = AppLanguage.system

    @ObservationIgnored
    @AppStorage("com.playwatch.storedAppRegion")
    private var storedAppRegion: AppRegion = AppRegion.system
    
    @ObservationIgnored
    var aiServer: AIServer {
        get {
            access(keyPath: \.aiServer)
            return self.storedAIServer
        }
        set {
            withMutation(keyPath: \.aiServer) {
                self.storedAIServer = newValue
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
    
    var mediaLocale: MediaLocale {
        MediaLocale(name: self.appLanguage.name,
                    code: self.appLanguage.languageCode,
                    region: self.appRegion.regionCode)
    }
}
