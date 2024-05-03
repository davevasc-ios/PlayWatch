//
//  Language.swift
//  PlayWatch
//
//  Created by David on 2/5/24.
//

import Foundation

enum Language: String, CaseIterable, Identifiable {
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
    
    var localized: String {
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
}

extension Language {
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
