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
    
    @State private var scale: CGFloat = 1
    @State private var opacity: CGFloat = 0
    
    var body: some View {
        ZStack {
            switch gameViewModel.state {
            case .error:
                ScrollView {
                    Text("Error loading")
                }
                .refreshable {
                    gameViewModel.action(.onRefresh)
                }
            case .empty:
                EmptyView()
            case .loading:
                ProgressView("Loading New Game")
                    .fontWeight(.heavy)
                    .scaleEffect(2.0)
                    .tint(.red)
                    .foregroundColor(.green)
                
            case .ready:
                Button {
                    gameViewModel.start()
                } label: {
                    Text("Ready? Start Now!")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            case .playing:
                VStack {
                    Text(gameViewModel.currentQuizzes.first?.quiz.question ?? "")
                        .font(.title2)
                        .padding()
                    ZStack {
                        GameStackView()
                        Text(gameViewModel.reaction)
                            .font(.title)
                            .scaleEffect(scale)
                            .opacity(opacity)
                            .padding()
                            .zIndex(Double(gameViewModel.currentQuizzes.count + 20))
                    }
                    .onChange(of: gameViewModel.next) {
                        opacity = 1
                        withAnimation(.easeInOut(duration: 2)) {
                            scale = 8
                            opacity = 0
                        } completion: {
                            scale = 1
                            gameViewModel.cleanReaction()
                        }
                    }
                }
                
            case .finish:
                VStack {
                    Text("Total: \(gameViewModel.points)/\(Constants.Game.quizCount)")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.blue)
                        .padding()
                    Button {
                        gameViewModel.action(.onRefresh)
                    } label: {
                        Text("Play Again!")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                }
            }
        }
        .onAppear {
            gameViewModel.action(.onAppear(localeManager.locale))
        }
        .navigationTitle(Text(Tab.game.localized))
    }
}



struct GameCardView: View {
    
    @Environment(GameViewModel.self) private var gameViewModel
    
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    
    let movie: Media
    let answer: Bool?
    
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
                            GameCardView(movie: movie, answer: answer)
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
        .gesture(DragGesture()
            .onChanged(onDragChanged)
            .onEnded(onDragEnded))
    }
}

private extension GameCardView {
    func returnToCenter() {
        withAnimation {
            xOffset = 0
            degrees = 0
        }
    }
    func swipeRight() {
        withAnimation {
            xOffset = 500
            degrees = 12
        } completion: {
            withAnimation {
                gameViewModel.removeCurrentQuiz(result: self.answer ?? true == true)
            }
        }
    }
    func swipeLeft() {
        withAnimation {
            xOffset = -500
            degrees = -12
        } completion: {
            withAnimation {
                gameViewModel.removeCurrentQuiz(result: self.answer ?? false == false)
            }
        }
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
    
        ZStack {
            ForEach(Array(gameViewModel.currentQuizzes.enumerated()), id: \.element.id) { index, quiz in
                GameCardView(movie: quiz.movie, answer: quiz.quiz.result)
                    .scaleEffect(1 - CGFloat(index) * 0.04)
                    .offset(x: 0, y: CGFloat(index) * -15)
                    .zIndex(Double(gameViewModel.currentQuizzes.count - index))
                
            }
        }
        //        .onChange(of: gameViewModel.gameQuiz) { oldValue, newValue in
        //
        //        }
    }
}


struct SwipeActionButtonsView: View {
    var body: some View {
        HStack {
            Button {
                
            } label: {
                Text("")
            }
        }
        
    }
}


#Preview("GameStackViewTest") {
    GameStackView()
        .environment(GameViewModel())
}

#Preview("GameCardViewTest") {
    GameCardView(movie: MockData.movie, answer: false)
        .environment(GameViewModel())
}

#Preview("SwipeActionIndicatorViewTest") {
    SwipeActionIndicatorView(xOffset: .constant(20))
}

#Preview("GameViewTest") {
    GameView(localeManager: LocaleManager())
        .environment(GameViewModel())
}


