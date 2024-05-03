//
//  Tab.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import Foundation

enum Tab: String, CaseIterable {
    case home,
         game,
         favorites,
         settings
    
    var systemImage: String {
        switch self {
        case .home: "house"
        case .game: "gamecontroller"
        case .favorites: "heart"
        case .settings: "gearshape"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
    
    var localized: String {
        switch self {
        case .home: return LocalizableString.home
        case .game: return LocalizableString.game
        case .favorites: return LocalizableString.favorites
        case .settings: return LocalizableString.settings
        }
    }
    
}

