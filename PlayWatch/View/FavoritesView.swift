//
//  FavoritesView.swift
//  PlayWatch
//
//  Created by David on 28/4/24.
//

import SwiftUI

struct FavoritesView: View {
    
    @Environment(AppService.self) private var appService
    
    private var testers: [String] = ["🏡 Jordi", "🐐 Noah", "👹 Tim", "🐶 Katie", "🦄 Marco"]
    private var secretMessages: [String] = ["", "", "", "", "", "", "¡¡Aberto Quirón a la carcel ya!!", "", "", "", "", "¡¡Ayuso frutera dimisión!!", "", "", "PP = Corrupción", "Mazón dimisión!", "Feijoó dimisión!", "PP = Montoro"]
    
    @State var tester = "Secret..."
    @State var secretMessage = ""
    @State private var press1 = false
    @State private var press2 = false
    @State private var backgroundColor: Color = .random
    
    var body: some View {
            
            NavigationStack {
                ScrollView {
                    VStack (spacing: 20) {
                        Text("Coming soon for Testers like...")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.random)
                        Text(tester)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.random)
                        Button {
                            update()
                            press1.toggle()
                        } label: {
                            Text("Punch x1")
                                .font(.title)
                                .padding()
                        }
                        .glassEffect(.clear.tint(.random.opacity(0.3)))
                        .sensoryFeedback(.success, trigger: press1)
                        
                        Button {
                            update()
                            press2.toggle()
                        } label: {
                            Text("Punch x2")
                                .font(.title)
                                .padding()
                        }
                        .glassEffect(.clear.tint(.random.opacity(0.3)))
                        .sensoryFeedback(.impact(weight: .heavy, intensity: 1.0), trigger: press2)
                        if !secretMessage.isEmpty {
                            Text(secretMessage)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.random)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                .containerBackground(Color.random.opacity(0.5), for: .navigation)
                .refreshable {
                    update()
                }
                .navigationTitle(Text(AppTab.favorites.localized))
            }
            .id(appService.preferencesService.selectedLanguage)
    }
    
    private func update() {
        tester = testers.randomElement() ?? ""
        secretMessage = secretMessages.randomElement() ?? ""
        backgroundColor = Color.random.opacity(0.5)
    }
    
}

#if DEBUG
#Preview {
    FavoritesView()
}
#endif
