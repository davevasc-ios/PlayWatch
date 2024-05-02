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
            if viewModel.state == .loading {
                ProgressView("Loading Game...")
                    .progressViewStyle(CircularProgressViewStyle()) // Estilo de vista circular
                    .scaleEffect(2.0)
                    .tint(.purple)
                    .foregroundColor(.red)
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
            if viewModel.state == .empty {
                try? await viewModel.start()
            }
        }
        .refreshable {
            try? await viewModel.refresh()
        }
    }
}

#Preview {
    GameView()
}
