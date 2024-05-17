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




struct GameCardView: View {
    
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    
    let movie: Media

    var body: some View {
        ZStack {
            ZStack (alignment: .top) {
                CacheAsyncImage(url: MovieDB.getImageUrl(file: movie.mediaImage, size: .medium)) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.clear
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
                                .frame(width: 50, height: 50)
                        }
                    case .success (let image):
                        image
                            .resizable()
                    case .failure (let error):
                        switch error {
                        case let urlError as URLError where urlError.code == .cancelled:
                            GameCardView(movie: movie)
                        default:
                            EmptyPosterView(text: movie.mediaName)
                        }
                    @unknown default: EmptyView()
                    }
                }
                SwipeActionIndicatorView(xOffset: $xOffset)
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .cornerRadius(10)
        .shadow(radius: 4, y: 4)
        .padding(EdgeInsets(top: 80, leading: 40, bottom: 40, trailing: 40))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(DragGesture()
            .onChanged(onDragChanged)
            .onEnded(onDragEnded))
    }
}

private extension GameCardView {
    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }
    func swipeRight() {
        xOffset = 500
        degrees = 12
    }
    func swipeLeft() {
        xOffset = -500
        degrees = -12
    }
}

private extension GameCardView {
    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }
    
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        
        switch value.translation.width {
        case let width where abs(width) <= abs(Constants.Game.screenCutoff):
            returnToCenter()
        case let width where width >= Constants.Game.screenCutoff:
            swipeRight()
        default:
            swipeLeft()
        }
    
    }
    
}



struct SwipeActionIndicatorView: View {
    @Binding var xOffset: CGFloat
    
    var body: some View {
        HStack {
            SwipeActionTagView(text: "TRUE",
                               color: .green,
                               degrees: -45,
                               opacity: Double(xOffset / Constants.Game.screenCutoff),
                               alignment: .leading)
            SwipeActionTagView(text: "FALSE",
                               color: .red,
                               degrees: 45,
                               opacity: -Double(xOffset / Constants.Game.screenCutoff),
                               alignment: .trailing)
        }
        .padding(.vertical, 35)
        .padding(.horizontal, 25)
    }
}

struct SwipeActionTagView: View {
    var text: String
    var color: Color
    var degrees: Double
    var opacity: Double
    var alignment: Alignment
    
    var body: some View {
        Text(text)
            .font(.title)
            .fontWeight(.heavy)
            .foregroundStyle(color)
            .padding(8)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(color, lineWidth: 2)
            }
            .rotationEffect(.degrees(degrees))
            .opacity(opacity)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}



struct GameStackView: View {
    
    @Environment(GameViewModel.self) private var gameViewModel
    
    var body: some View {
    
//        let data = gameViewModel.gameQuiz
        let data = MockData.gameQuiz
        
        ZStack {
            ForEach (data) { quiz in
                VStack {
                    Text(quiz.quiz.question ?? "")
                        .background(Color.white)
                    GameCardView(movie: quiz.movie)
                }
            }
            
        }
        
    }
}


#Preview("GameStackViewTest") {
    GameStackView()
        .environment(GameViewModel())
}

#Preview("GameCardViewTest") {
    GameCardView(movie: MockData.movie)
}

#Preview("SwipeActionIndicatorViewTest") {
    SwipeActionIndicatorView(xOffset: .constant(20))
}

#Preview("GameViewTest") {
    GameView(localeManager: LocaleManager())
        .environment(GameViewModel())
}


