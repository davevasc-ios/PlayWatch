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
    
    var name: String {
        if self == .system {
            Locale(identifier: AppLanguage.english.languageCode).localizedString(forRegionCode: self.regionCode) ?? String(localized: AppRegion.unitedStates.localized.defaultValue)
        } else {
            String(localized: self.localized.defaultValue)
        }
    }
    
    var regionCode: String {
        switch self {
        case .system: return Locale.current.region?.identifier ?? AppRegion.unitedStates.regionCode
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
    
    var languageCode: String {
        switch self {
        case .system: return Locale.current.region?.identifier ?? AppRegion.unitedStates.regionCode
        case .unitedStates, .unitedKingdom: return AppLanguage.english.languageCode
        case .spain, .mexico: return AppLanguage.spanish.languageCode
        case .basqueCountry: return AppLanguage.basque.languageCode
        case .catalonia: return AppLanguage.catalan.languageCode
        case .france: return AppLanguage.french.languageCode
        case .italy: return AppLanguage.italian.languageCode
        case .portugal, .brazil: return AppLanguage.portuguese.languageCode
        case .germany: return AppLanguage.german.languageCode
        }
    }
    
    var localized: LocalizedStringResource {
        switch self {
        case .system: return LocalizableString.systemRegionName
        case .unitedStates: return LocalizableString.unitedStatesRegionName
        case .unitedKingdom: return LocalizableString.unitedKingdomRegionName
        case .spain: return LocalizableString.spainRegionName
        case .basqueCountry: return LocalizableString.basqueCountryRegionName
        case .catalonia: return LocalizableString.cataloniaRegionName
        case .mexico: return LocalizableString.mexicoRegionName
        case .france: return LocalizableString.franceRegionName
        case .italy: return LocalizableString.italyRegionName
        case .portugal: return LocalizableString.portugalRegionName
        case .brazil: return LocalizableString.brazilRegionName
        case .germany: return LocalizableString.germanyRegionName
        }
    }
    
    var nativeName: String {
        if self == .system {
            return String(localized: self.localized)
        } else {
            var region = self.localized
            region.locale = Locale(identifier: self.languageCode)
            return String(localized: region)
        }
    }
}
