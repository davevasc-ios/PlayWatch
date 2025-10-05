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

protocol SettingsWritable: Sendable {
    var selectedTheme: AppTheme { get set }
    var selectedLanguage: AppLanguage { get set }
    var selectedRegion: AppRegion { get set }
    var selectedServer: AIServer { get set }
}

protocol SettingsManaging: SettingsWritable {
    var keys: SettingsKeys { get }
    var defaults: UserDefaults { get }
}

extension SettingsManaging {
    
    var defaults: UserDefaults { .standard }
    
    var selectedTheme: AppTheme {
        get {
            guard let storedThemeValue = defaults.string(forKey: keys.theme),
                  let savedTheme = AppTheme(rawValue: storedThemeValue) else { return .light }
            return savedTheme
        }
        set {
            defaults.set(newValue.rawValue, forKey: keys.theme)
        }
    }
    
    var selectedLanguage: AppLanguage {
        get {
            guard let storedValue = self.defaults.string(forKey: keys.language),
                  let savedLanguage = AppLanguage(rawValue: storedValue) else { return .system }
            return savedLanguage
        }
        set { self.defaults.set(newValue.rawValue, forKey: keys.language) }
    }
    
    var selectedRegion: AppRegion {
        get {
            guard let storedValue = self.defaults.string(forKey: keys.region),
                  let savedRegion = AppRegion(rawValue: storedValue) else { return .system }
            return savedRegion
        }
        set { self.defaults.set(newValue.rawValue, forKey: keys.region) }
    }

    var selectedServer: AIServer {
        get {
            guard let storedValue = self.defaults.string(forKey: keys.server),
                  let savedServer = AIServer(rawValue: storedValue) else { return .deepSeek }
            return savedServer
        }
        set { self.defaults.set(newValue.rawValue, forKey: keys.server) }
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

struct SettingsUtility: SettingsManaging {
    let keys: SettingsKeys = .production
}
