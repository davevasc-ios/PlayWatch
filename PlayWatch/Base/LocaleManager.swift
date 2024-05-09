//
//  LanguageManager.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import Foundation
import Observation

@Observable
final class LocaleManager {
    
    private let defaults = UserDefaults.standard
    private let appLanguageKey = "com.playwatch.appLanguage"
    private let appRegionKey = "com.playwatch.appRegion"
    
    var appLanguage: AppLanguage {
        get {
            access(keyPath: \.appLanguage)
            guard let key = defaults.string(forKey: appLanguageKey),
                  let lang = AppLanguage(rawValue: key) else {
                return .system
            }
            return lang
        }
        set {
            withMutation(keyPath: \.appLanguage) {
                defaults.set(newValue.rawValue, forKey: appLanguageKey)
            }
        }
    }

    var appRegion: AppRegion {
        get {
            access(keyPath: \.appRegion)
            guard let key = defaults.string(forKey: appRegionKey),
                  let region = AppRegion(rawValue: key) else {
                return .system
            }
            return region
        }
        set {
            withMutation(keyPath: \.appRegion) {
                defaults.set(newValue.rawValue, forKey: appRegionKey)
            }
        }
    }
    
    var appLocale: Locale {
        Locale(identifier: "\(self.appLanguage.code)-\(self.appRegion.code)")
    }
    
    var locale: MovieDB.Locale {
        MovieDB.Locale(name: self.appLanguage.name,
                       code: self.appLanguage.code,
                       region: self.appRegion.code)
    }
}
