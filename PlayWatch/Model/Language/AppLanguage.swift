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
    
    var nativeName: String {
        switch self {
        case .system: String(localized: "\(self.localized)")
        case .english: "English"
        case .spanish: "Español"
        case .basque: "Euskara"
        case .catalan: "Català"
        case .french: "Français"
        case .italian: "Italiano"
        case .portuguese: "Português"
        case .german: "Deutsch"
        }
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
        case .system: Localizable.Settings.systemLanguageName
        case .english: Localizable.Settings.englishLanguageName
        case .spanish: Localizable.Settings.spanishLanguageName
        case .basque: Localizable.Settings.basqueLanguageName
        case .catalan: Localizable.Settings.catalanLanguageName
        case .french: Localizable.Settings.frenchLanguageName
        case .italian: Localizable.Settings.italianLanguageName
        case .portuguese: Localizable.Settings.portugueseLanguageName
        case .german: Localizable.Settings.germanLanguageName
        }
    }
}
