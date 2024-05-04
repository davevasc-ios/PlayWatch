//
//  Language.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case system,
         english = "en",
         spanish = "es",
         basque = "eu",
         catalan = "ca",
         french = "fr",
         italian = "it",
         portuguese = "pt-PT",
         german = "de"
    
    var id: Self { self }
    
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
    
    var emoji: String {
        switch self {
        case .system: "🌍"
        case .english: "📚"
        case .spanish: "💃"
        case .basque: "⛰️"
        case .catalan: "🐉"
        case .french: "🥖"
        case .italian: "🍕"
        case .portuguese: "🎭"
        case .german: "🍺"
        }
    }
}
