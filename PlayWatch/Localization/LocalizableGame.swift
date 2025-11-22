//
//  LocalizableGame.swift
//  PlayWatch
//
//  Created by David on 22/11/25.
//

import Foundation

extension Localizable {
    
    // MARK: - Table LocalizableGame
    enum Game {
        
        static let title = LocalizedStringResource(
            "game.section.title",
            defaultValue: "Game",
            table: "LocalizableGame",
            comment: "Game section title"
        )
    }
}
