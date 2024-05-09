//
//  GameView.swift
//  PlayWatch
//
//  Created by David on 21/4/24.
//

import SwiftUI

struct GameView: View {
    
    @Environment(GameViewModel.self) private var viewModel
    
    @Bindable var localeManager: LocaleManager
    
    var body: some View {
        NavigationStack {
            if viewModel.state == .loading {
                ProgressView("Loading Game...")
                    .progressViewStyle(CircularProgressViewStyle()) // Estilo de vista circular
                    .scaleEffect(2.0)
                    .tint(.purple)
                    .foregroundColor(.red)
            } else if viewModel.state == .success {
                ScrollView {
                    VStack (spacing: 20) {
                        ForEach (viewModel.quizList, id: \.self) { quiz in
                            VStack {
                                Text(quiz.question ?? "")
                                Text("\(quiz.result ?? true)")
                            }
                        }
                    }
                }
                .refreshable {
                    try? await viewModel.refresh(locale: localeManager.locale)
                }
                .navigationTitle(Text(Tab.game.localized))
            } else {
                ScrollView {
                    Text("Error loading")
                }
                .refreshable {
                    try? await viewModel.refresh(locale: localeManager.locale)
                }
            }
        }
        .onAppear {
            Task {
                if viewModel.state == .empty {
                    try? await viewModel.start(locale: localeManager.locale)
                }
            }
        }
        
    }
}

#Preview {
    GameView(localeManager: LocaleManager())
}
