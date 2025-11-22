//
//  Localizable.swift
//  PlayWatch
//
//  Created by David on 22/11/25.
//

import Foundation

// MARK: - Table LocalizableAccount
enum Localizable {
    
    static let appTitle = LocalizedStringResource(
        "app.title",
        defaultValue: "PlayWatch",
        table: "Localizable",
        comment: "App title"
    )
}
