//
//  Language.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
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
            Locale(identifier: AppLanguage.english.code).localizedString(forLanguageCode: AppLanguage.system.code) ?? String(localized: AppLanguage.english.localized.defaultValue)
        } else {
            String(localized: self.localized.defaultValue)
        }
    }
    
    var code: String {
        switch self {
        case .system: return Locale(identifier: Locale.preferredLanguages.first ?? AppLanguage.english.code).language.languageCode?.identifier ?? AppLanguage.english.code
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
        switch self {
        case .system: return String(localized: LocalizableString.systemLanguageName)
        case .english:
            var lang = LocalizableString.englishLanguageName
            lang.locale = Locale(identifier: AppLanguage.english.code)
            return String(localized: lang)
        case .spanish:
            var lang = LocalizableString.spanishLanguageName
            lang.locale = Locale(identifier: AppLanguage.spanish.code)
            return String(localized: lang)
        case .basque:
            var lang = LocalizableString.basqueLanguageName
            lang.locale = Locale(identifier: AppLanguage.basque.code)
            return String(localized: lang)
        case .catalan:
            var lang = LocalizableString.catalanLanguageName
            lang.locale = Locale(identifier: AppLanguage.catalan.code)
            return String(localized: lang)
        case .french: 
            var lang = LocalizableString.frenchLanguageName
            lang.locale = Locale(identifier: AppLanguage.french.code)
            return String(localized: lang)
        case .italian:
            var lang = LocalizableString.italianLanguageName
            lang.locale = Locale(identifier: AppLanguage.italian.code)
            return String(localized: lang)
        case .portuguese:
            var lang = LocalizableString.portugueseLanguageName
            lang.locale = Locale(identifier: AppLanguage.portuguese.code)
            return String(localized: lang)
        case .german: 
            var lang = LocalizableString.germanLanguageName
            lang.locale = Locale(identifier: AppLanguage.german.code)
            return String(localized: lang)
        }
    }
}

enum AppRegion: String, CaseIterable, Identifiable {
    case system,
         unitedStates,
         unitedKingdom,
         spain,
         basqueCountry,
         catalonia,
         mexico,
         france,
         italy,
         portugal,
         brazil,
         germany
    
    var id: Self { self }
    
//    var name: String {
//        if self == .system {
//            Locale(identifier: AppLanguage.english.code).localizedString(forRegionCode: Locale.current.region?.identifier ?? AppRegion.unitedStates.code) ?? String(localized: AppRegion.unitedStates.localized.defaultValue)
//        } else {
//            String(localized: self.localized.defaultValue)
//        }
//    }
    
    var code: String {
        switch self {
        case .system: return Locale.current.region?.identifier ?? AppRegion.unitedStates.code
        case .unitedStates: return "US"
        case .unitedKingdom: return "GB"
        case .spain, .basqueCountry, .catalonia: return "ES"
        case .mexico: return "MX"
        case .france: return "FR"
        case .italy: return "IT"
        case .portugal: return "PT"
        case .brazil: return "BR"
        case .germany: return "DE"
        }
    }
    
//    var localized: LocalizedStringResource {
//        switch self {
//        case .system: return LocalizableString.systemRegionName
//        case .unitedStates: return LocalizableString.unitedStatesRegionName
//        case .unitedKingdom: return LocalizableString.unitedKingdomRegionName
//        case .spain: return LocalizableString.spainRegionName
//        case .basqueCountry: return LocalizableString.basqueCountryRegionName
//        case .catalonia: return LocalizableString.cataloniaRegionName
//        case .mexico: return LocalizableString.mexicoRegionName
//        case .france: return LocalizableString.franceRegionName
//        case .italy: return LocalizableString.italyRegionName
//        case .portugal: return LocalizableString.portugalRegionName
//        case .brazil: return LocalizableString.brazilRegionName
//        case .germany: return LocalizableString.germanyRegionName
//        }
//    }
}
