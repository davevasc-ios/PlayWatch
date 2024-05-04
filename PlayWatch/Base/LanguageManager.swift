//
//  LanguageManager.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import Foundation
import Observation

@Observable
final class LanguageManager {
    
    private let defaults = UserDefaults.standard
    private let currentLanguageCodeKey = "com.playwatch.currentLanguageCode"
    
    var currentLanguageCode: String {
        get {
            access (keyPath: \.currentLanguageCode)
            guard let locale = defaults.string(forKey: currentLanguageCodeKey),
                  let lang = AppLanguage(rawValue: locale) else {
                return Locale.current.language.languageCode?.identifier ?? AppLanguage.english.rawValue
            }
            return lang.rawValue
        }
        set {
            withMutation(keyPath: \.currentLanguageCode) {
                defaults.set(newValue, forKey: currentLanguageCodeKey)
            }
        }
    }
    
}
