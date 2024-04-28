//
//  GameView.swift
//  PlayWatch
//
//  Created by David on 21/4/24.
//

import SwiftUI

struct GameView: View {
    
    @State private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle()) // Estilo de vista circular
                    .scaleEffect(2.0)
                    .tint(.purple)
            } else {
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
            }
        }
        .task {
            try? await viewModel.start()
        }
    }
}

#Preview {
    GameView()
}
