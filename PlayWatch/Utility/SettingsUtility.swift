//
//  SettingsUtility.swift
//  PlayWatch
//
//  Created by David on 1/9/25.
//

import Foundation

struct SettingsKeys {
    let theme: String
    let language: String
    let region: String
    let server: String
}

protocol SettingsUtilityProtocol: Sendable {
    var keys: SettingsKeys { get }
}

extension SettingsUtilityProtocol {
   
    var defaults: UserDefaults { .standard }
    
    var selectedTheme: SettingsView.Theme {
        get {
            guard let storedThemeValue = defaults.string(forKey: keys.theme),
                  let savedTheme = SettingsView.Theme(rawValue: storedThemeValue) else { return .light }
            return savedTheme
        }
        set {
            defaults.set(newValue.rawValue, forKey: keys.theme)
        }
    }
    
    var selectedLanguage: AppLanguage {
        get {
            guard let storedLanguageValue = self.defaults.string(forKey: keys.language),
                  let savedLanguage = AppLanguage(rawValue: storedLanguageValue) else { return .system }
            return savedLanguage
        }
        set {
            self.defaults.set(newValue.rawValue, forKey: keys.language)
        }
    }
    
    var selectedRegion: AppRegion {
        get {
            guard let storedRegionValue = self.defaults.string(forKey: keys.region),
                  let savedRegion = AppRegion(rawValue: storedRegionValue) else { return .system }
            return savedRegion
        }
        set {
            self.defaults.set(newValue.rawValue, forKey: keys.region)
        }
    }

    var selectedServer: AIServer {
        get {
            guard let storedServerValue = self.defaults.string(forKey: keys.server),
                  let savedServer = AIServer(rawValue: storedServerValue) else { return .deepSeek }
            return savedServer
        }
        set {
            self.defaults.set(newValue.rawValue, forKey: keys.server)
        }
    }
    
    var mediaLocale: MediaLocale {
        MediaLocale(
            name: selectedLanguage.name,
            code: selectedLanguage.languageCode,
            region: selectedRegion.regionCode
        )
    }
}

extension SettingsKeys {
    static let production = SettingsKeys(
        theme: "production.settings.theme",
        language: "production.settings.language",
        region: "production.settings.region",
        server: "production.settings.server"
    )
}

struct SettingsUtility: SettingsUtilityProtocol {
    var keys: SettingsKeys = .production
}

extension SettingsKeys {
    static let preview = SettingsKeys(
        theme: "preview.settings.theme",
        language: "preview.settings.language",
        region: "preview.settings.region",
        server: "preview.settings.server"
    )
}

struct SettingsUtilityPreview: SettingsUtilityProtocol {
    var keys: SettingsKeys = .preview
}
