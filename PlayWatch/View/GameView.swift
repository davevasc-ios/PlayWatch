//
//  GameView.swift
//  PlayWatch
//
//  Created by David on 21/4/24.
//

import SwiftUI

struct GameView: View {
    
    private var testers: [String] = ["Jordi", "Noah", "Tim", "Katy"]

    var body: some View {
        ZStack {
            Color.systemRandom.ignoresSafeArea() // Background color
                VStack { // Center vertically and horizontally
                    Text("🎲 coming soon for \(testers.randomElement() ?? "") 🃏")
                        .font(.title) // Adjust font size as needed
                        .fontWeight(.bold) // Adjust font weight as needed
                        .foregroundColor(.white) // Adjust text color as needed
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the entire ZStack
                .ignoresSafeArea() // Extend content to safe area edges
        }
    }
}

#Preview {
    GameView()
}
