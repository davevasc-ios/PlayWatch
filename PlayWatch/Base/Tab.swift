//
//  Tab.swift
//  PlayWatch
//
//  Created by David on 14/4/24.
//

import Foundation

enum Tab: String, CaseIterable {
    case home = "Home"
    case game = "Game"
    case favorites = "Favorites"
    case settings = "Settings"
    
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
    
}

