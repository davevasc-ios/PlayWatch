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
    private let currentLocaleKey = "com.playwatch.currentLocale"
    
    init() {
        self.start()
    }
    
    var currentLanguage: Language {
        get {
            access (keyPath: \.currentLanguage)
            guard let locale = defaults.string(forKey: currentLocaleKey),
                  let lang = Language(rawValue: locale) else {
                return .system
            }
            return lang
        }
        set {
            withMutation(keyPath: \.currentLanguage) {
                defaults.set(newValue.rawValue, forKey: currentLocaleKey)
            }
        }
    }
    
    private func start() {
        
    }
    private func changeAppLanguage() {
        
    }
    
}
