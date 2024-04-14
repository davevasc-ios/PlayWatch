//
//  ColorExtension.swift
//  PlayWatch
//
//  Created by David on 13/4/24.
//

import SwiftUI

extension Color {

    static var random: Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
    
    static var systemRandom: Color {
        let systemColors: [Color] = [.red, .blue, .green, .yellow, .orange, .pink, .purple, .gray, .teal, .indigo, .brown, .cyan, .mint]
        let randomIndex = Int.random(in: 0..<systemColors.count)
        return systemColors[randomIndex]
    }
}


