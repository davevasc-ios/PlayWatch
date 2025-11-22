//
//  LocalizableFavorites.swift
//  PlayWatch
//
//  Created by David on 22/11/25.
//

import Foundation

extension Localizable {
    
    // MARK: - Table LocalizableFavorites
    enum Favorites {
        
        static let title = LocalizedStringResource(
            "favorites.section.title",
            defaultValue: "Favorites",
            table: "LocalizableFavorites",
            comment: "Favorites section title"
        )
    }
}
