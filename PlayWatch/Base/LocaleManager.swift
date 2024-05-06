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
    
    var appLocale: Locale {
        self.appLanguage == AppLanguage.system ? Locale.current : Locale(identifier: self.appLanguage.rawValue)
    }
    
    var languageName: String {
        String(localized: AppLanguage(rawValue: self.appLocale.identifier)?.localized.defaultValue ?? AppLanguage.english.localized.defaultValue)
    }
}
