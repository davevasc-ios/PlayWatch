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
                    .scaleEffect(2.0)
                    .tint(.purple)
                    .foregroundColor(.blue)
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
                    viewModel.refresh(locale: localeManager.locale)
                }
                .navigationTitle(Text(Tab.game.localized))
            } else {
                ScrollView {
                    Text("Error loading")
                }
                .refreshable {
                    viewModel.refresh(locale: localeManager.locale)
                }
            }
        }
        .onAppear {
            viewModel.start(locale: localeManager.locale)
        }
    }
}

#Preview {
    GameView(localeManager: LocaleManager())
}
