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
            guard let locale = defaults.string(forKey: appLanguageKey),
                  let lang = AppLanguage(rawValue: locale) else {
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
}
