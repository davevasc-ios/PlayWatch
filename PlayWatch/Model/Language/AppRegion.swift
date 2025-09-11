//
//  AppRegion.swift
//  PlayWatch
//
//  Created by David on 5/1/25.
//

import Foundation

enum AppRegion: String, CaseIterable, Identifiable, Codable {
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
        case .system: LocalizableString.systemRegionName
        case .unitedStates: LocalizableString.unitedStatesRegionName
        case .unitedKingdom: LocalizableString.unitedKingdomRegionName
        case .spain: LocalizableString.spainRegionName
        case .basqueCountry: LocalizableString.basqueCountryRegionName
        case .catalonia: LocalizableString.cataloniaRegionName
        case .mexico: LocalizableString.mexicoRegionName
        case .france: LocalizableString.franceRegionName
        case .italy: LocalizableString.italyRegionName
        case .portugal: LocalizableString.portugalRegionName
        case .brazil: LocalizableString.brazilRegionName
        case .germany: LocalizableString.germanyRegionName
        }
    }
    
    var nativeName: String {
        if self == .system {
            return String(localized: "\(self.localized)")
        } else {
            var region = self.localized
            region.locale = Locale(identifier: self.languageCode)
            return String(localized: "\(region)")
        }
    }
}
