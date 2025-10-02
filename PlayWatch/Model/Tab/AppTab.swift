//
//  AppTab.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import Foundation

enum AppTab: CaseIterable {
    case home,
         game,
         favorites,
         settings,
         search
    
    var systemImage: String {
        switch self {
        case .home: "house"
        case .game: "gamecontroller"
        case .favorites: "heart"
        case .settings: "gearshape"
        case .search: "magnifyingglass"
        }
    }
    
    var index: Int {
        return AppTab.allCases.firstIndex(of: self) ?? 0
    }
    
    var localized: LocalizedStringResource {
        switch self {
        case .home: LocalizableString.home
        case .game: LocalizableString.game
        case .favorites: LocalizableString.favorites
        case .settings: LocalizableString.settings
        case .search: LocalizableString.search
        }
    }
}
