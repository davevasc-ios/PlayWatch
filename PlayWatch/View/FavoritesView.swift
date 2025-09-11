//
//  FavoritesView.swift
//  PlayWatch
//
//  Created by David on 28/4/24.
//

import SwiftUI

struct FavoritesView: View {
    
    private var testers: [String] = ["🏡 Jordi", "🐐 Noah", "👹 Tim", "🐶 Katie", "🦄 Marco"]
    private var secretMessages: [String] = ["", "", "", "", "", "", "¡¡Aberto Quirón a la carcel ya!!", "", "", "", "", "¡¡Ayuso frutera dimisión!!", "", "", "PP = Corrupción", "Mazón dimisión!", "Feijoó dimisión!", "PP = Montoro"]

    @State var tester = "Secret..."
    @State var secretMessage = ""
    
    var body: some View {
        NavigationStack{
            ScrollView {
                ZStack {
                    Color.systemRandom.ignoresSafeArea() // Background color
                    VStack (spacing: 20) {
                        Text("Coming soon for Testers like...")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(tester)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Button {
                            tester = testers.randomElement() ?? ""
                            secretMessage = secretMessages.randomElement() ?? ""
                        } label: {
                            Text("Punch")
                                .font(.title)
                                .foregroundColor(.random)
                                .padding()
                                .background(
                                    Capsule()
                                        .foregroundColor(Color.random)
                                )
                        }
                        Text(secretMessage)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .background(Color.random)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Fill the entire ZStack
                    .ignoresSafeArea() // Extend content to safe area edges
                }
            }
            .refreshable {
                tester = testers.randomElement() ?? ""
                secretMessage = secretMessages.randomElement() ?? ""
            }
            .navigationTitle(Text(AppTab.favorites.localized))
        }
    }
}


#Preview {
    FavoritesView()
}
