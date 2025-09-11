//
//  AppTheme.swift
//  PlayWatch
//
//  Created by David on 11/9/25.
//

import Foundation

enum AppTheme: String, CaseIterable, Identifiable, Codable {
    case light = "Ligero"
    case dark = "Oscuro"
    case rainbows = "Rainbows"
    case pink = "Pink"
    case purple = "Purple"
    case red = "Red"
    case green = "Green"
    case yellow = "Yellow"
    
    var id: Self { self }
}
