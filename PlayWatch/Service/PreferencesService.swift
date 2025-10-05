//
//  PreferencesService.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation
import Observation

protocol MediaLocaleProvider {
    var mediaLocale: MediaLocale { get }
}

protocol GameDataProvider {
    var gameData: GameData { get }
}

@Observable
final class PreferencesService: MediaLocaleProvider, GameDataProvider {
    
    // MARK: - Private Properties
    @ObservationIgnored private var settingsUtility: SettingsWritable

    // MARK: - Initialization
    init(
        settingsUtility: SettingsWritable
    ) {
        self.settingsUtility = settingsUtility
    }

    
    var selectedTheme: AppTheme {
        get {
            access(keyPath: \.selectedTheme)
            return settingsUtility.selectedTheme
        }
        set {
            withMutation(keyPath: \.selectedTheme) {
                settingsUtility.selectedTheme = newValue
            }
        }
    }
    
    var selectedLanguage: AppLanguage {
        get {
            access(keyPath: \.selectedLanguage)
            return settingsUtility.selectedLanguage
        }
        set {
            withMutation(keyPath: \.selectedLanguage) {
                settingsUtility.selectedLanguage = newValue
            }
        }
    }
    
    var selectedRegion: AppRegion {
        get {
            access(keyPath: \.selectedRegion)
            return settingsUtility.selectedRegion
        }
        set {
            withMutation(keyPath: \.selectedRegion) {
                settingsUtility.selectedRegion = newValue
            }
        }
    }
    
    var selectedServer: AIServer {
        get {
            access(keyPath: \.selectedServer)
            return settingsUtility.selectedServer
        }
        set {
            withMutation(keyPath: \.selectedServer) {
                settingsUtility.selectedServer = newValue
            }
        }
    }
    
    var appLocale: Locale {
        Locale(identifier: "\(self.selectedLanguage.languageCode)-\(self.selectedRegion.regionCode)")
    }
    
    var mediaLocale: MediaLocale {
        MediaLocale(
            code: selectedLanguage.languageCode,
            region: selectedRegion.regionCode
        )
    }
    
    var gameData: GameData {
        GameData(
            server: selectedServer,
            mediaLocale: mediaLocale,
            language: selectedLanguage.englishName
        )
    }
}
