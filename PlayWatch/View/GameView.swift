//
//  GameView.swift
//  PlayWatch
//
//  Created by David on 21/4/24.
//

import SwiftUI

struct GameView: View {
    @Bindable var localeManager: LocaleManager
    @Environment(GameViewModel.self) private var gameViewModel
    
    var body: some View {
        NavigationStack {
            if gameViewModel.state == .loading {
                ProgressView("Loading Game...")
                    .scaleEffect(2.0)
                    .tint(.purple)
                    .foregroundColor(.blue)
            } else if gameViewModel.state == .success {
                ScrollView {
                    VStack (spacing: 20) {
                        ForEach (gameViewModel.quizList, id: \.self) { quiz in
                            VStack {
                                Text(quiz.question ?? "")
                                Text("\(quiz.result ?? true)")
                            }
                        }
                    }
                }
                .refreshable {
                    gameViewModel.action(.onRefresh)
                }
                .navigationTitle(Text(Tab.game.localized))
            } else {
                ScrollView {
                    Text("Error loading")
                }
                .refreshable {
                    gameViewModel.action(.onRefresh)
                }
            }
        }
        .onAppear {
            gameViewModel.action(.onAppear(localeManager.locale))
        }
    }
}

#Preview {
    GameView(localeManager: LocaleManager())
}
