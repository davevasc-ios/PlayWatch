//
//  AppLanguage.swift
//  PlayWatch
//
//  Created by David on 5/1/25.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case system,
         english,
         spanish,
         basque,
         catalan,
         french,
         italian,
         portuguese,
         german
    
    var id: Self { self }
    
    var name: String {
        if self == .system {
            Locale(identifier: AppLanguage.english.languageCode).localizedString(forLanguageCode: self.languageCode) ?? String(localized: AppLanguage.english.localized.defaultValue)
        } else {
            String(localized: self.localized.defaultValue)
        }
    }
    
    var languageCode: String {
        switch self {
        case .system: return Locale(identifier: Locale.preferredLanguages.first ?? AppLanguage.english.languageCode).language.languageCode?.identifier ?? AppLanguage.english.languageCode
        case .english: return "en"
        case .spanish: return "es"
        case .basque: return "eu"
        case .catalan: return "ca"
        case .french: return "fr"
        case .italian: return "it"
        case .portuguese: return "pt"
        case .german: return "de"
        }
    }
    
    var localized: LocalizedStringResource {
        switch self {
        case .system: return LocalizableString.systemLanguageName
        case .english: return LocalizableString.englishLanguageName
        case .spanish: return LocalizableString.spanishLanguageName
        case .basque: return LocalizableString.basqueLanguageName
        case .catalan: return LocalizableString.catalanLanguageName
        case .french: return LocalizableString.frenchLanguageName
        case .italian: return LocalizableString.italianLanguageName
        case .portuguese: return LocalizableString.portugueseLanguageName
        case .german: return LocalizableString.germanLanguageName
        }
    }
    
    var nativeName: String {
        if self == .system {
            return String(localized: self.localized)
        } else {
            var lang = self.localized
            lang.locale = Locale(identifier: self.languageCode)
            return String(localized: lang)
        }
    }
}
