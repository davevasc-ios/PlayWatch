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
        case .home: Localizable.Home.title
        case .game: Localizable.Game.title
        case .favorites: Localizable.Favorites.title
        case .settings: Localizable.Settings.title
        case .search: Localizable.Search.title
        }
    }
}
