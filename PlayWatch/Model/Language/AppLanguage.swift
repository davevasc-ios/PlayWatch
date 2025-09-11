//
//  AppLanguage.swift
//  PlayWatch
//
//  Created by David on 5/1/25.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable, Codable {
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
    
    var englishName: String {
        Locale(identifier: AppLanguage.english.languageCode).localizedString(forLanguageCode: self.languageCode) ?? AppLanguage.english.rawValue
    }
    
    var languageCode: String {
        switch self {
        case .system: Locale(identifier: Locale.preferredLanguages.first ?? AppLanguage.english.languageCode).language.languageCode?.identifier ?? AppLanguage.english.languageCode
        case .english: "en"
        case .spanish: "es"
        case .basque: "eu"
        case .catalan: "ca"
        case .french: "fr"
        case .italian: "it"
        case .portuguese: "pt"
        case .german: "de"
        }
    }
    
    var localized: LocalizedStringResource {
        switch self {
        case .system: LocalizableString.systemLanguageName
        case .english: LocalizableString.englishLanguageName
        case .spanish: LocalizableString.spanishLanguageName
        case .basque: LocalizableString.basqueLanguageName
        case .catalan: LocalizableString.catalanLanguageName
        case .french: LocalizableString.frenchLanguageName
        case .italian: LocalizableString.italianLanguageName
        case .portuguese: LocalizableString.portugueseLanguageName
        case .german: LocalizableString.germanLanguageName
        }
    }
    
    var nativeName: String {
        if self == .system {
            return String(localized: "\(self.localized)")
        } else {
            var lang = self.localized
            lang.locale = Locale(identifier: self.languageCode)
            return String(localized: "\(lang)")
        }
    }
}
