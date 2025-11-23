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
    
    var nativeName: String {
        switch self {
        case .system: String(localized: "\(self.localized)")
        case .unitedStates: "United States"
        case .unitedKingdom: "United Kingdom"
        case .spain: "España"
        case .basqueCountry: "Euskal Herria"
        case .catalonia: "Catalunya"
        case .mexico: "México"
        case .france: "France"
        case .italy: "Italia"
        case .portugal: "Portugal"
        case .brazil: "Brasil"
        case .germany: "Deutschland"
        }
    }
        
    var regionCode: String {
        switch self {
        case .system: Locale.current.region?.identifier ?? AppRegion.unitedStates.regionCode
        case .unitedStates: "US"
        case .unitedKingdom: "GB"
        case .spain, .basqueCountry, .catalonia: "ES"
        case .mexico: "MX"
        case .france: "FR"
        case .italy: "IT"
        case .portugal: "PT"
        case .brazil: "BR"
        case .germany: "DE"
        }
    }
    
    var languageCode: String {
        switch self {
        case .system: Locale.current.region?.identifier ?? AppRegion.unitedStates.regionCode
        case .unitedStates, .unitedKingdom: AppLanguage.english.languageCode
        case .spain, .mexico: AppLanguage.spanish.languageCode
        case .basqueCountry: AppLanguage.basque.languageCode
        case .catalonia: AppLanguage.catalan.languageCode
        case .france: AppLanguage.french.languageCode
        case .italy: AppLanguage.italian.languageCode
        case .portugal, .brazil: AppLanguage.portuguese.languageCode
        case .germany: AppLanguage.german.languageCode
        }
    }
    
    var localized: LocalizedStringResource {
        switch self {
        case .system: Localizable.Settings.systemRegionName
        case .unitedStates: Localizable.Settings.unitedStatesRegionName
        case .unitedKingdom: Localizable.Settings.unitedKingdomRegionName
        case .spain: Localizable.Settings.spainRegionName
        case .basqueCountry: Localizable.Settings.basqueCountryRegionName
        case .catalonia: Localizable.Settings.cataloniaRegionName
        case .mexico: Localizable.Settings.mexicoRegionName
        case .france: Localizable.Settings.franceRegionName
        case .italy: Localizable.Settings.italyRegionName
        case .portugal: Localizable.Settings.portugalRegionName
        case .brazil: Localizable.Settings.brazilRegionName
        case .germany: Localizable.Settings.germanyRegionName
        }
    }
}
