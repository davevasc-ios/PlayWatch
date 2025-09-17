//
//  GameView.swift
//  PlayWatch
//
//  Created by David on 21/4/24.
//

import SwiftUI

struct GameView: View {
    @Environment(AppService.self) private var appService

    var body: some View {
        @Bindable var settings = appService.preferencesService
        
        ZStack {
            switch appService.gameService.state {
            case .error:
                ScrollView {
                    Text("Error on \(appService.preferencesService.selectedServer.rawValue) server, change on Settings")
                }
                .refreshable {
                    appService.gameService.on(.refreshGame)
                }
            case .empty:
                VStack {
                    Text("Quiz Game")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.purple.gradient)
                    Text("Powered by \(appService.preferencesService.selectedServer.rawValue)")
                        .font(.subheadline)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.purple.gradient)
                    Button {
                        appService.gameService.on(.viewAppear)
                    } label: {
                        Text("Load Game")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple.gradient)
                            .cornerRadius(15)
                    }
                    HStack {
                        Text("Server:")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.purple.gradient)
                        Picker("Server", selection: $settings.selectedServer) {
                            ForEach(AIServer.allCases) { server in
                                Text(server.rawValue)
                                    .tag(server)
                            }
                        }
                    }
                }
            case .loading:
                VStack {
                    Text("Loading...")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.red.gradient)
                    ProgressView()
                        .fontWeight(.heavy)
                        .scaleEffect(2.0)
                        .tint(.red)
                        .padding()
                }
            case .ready:
                VStack {
                    Text("Ready?")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(Color.blue.gradient)
                    Button {
                        appService.gameService.start()
                    } label: {
                        Text("Start!")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.gradient)
                            .cornerRadius(15)
                    }
                }
            case .playing:
                VStack (spacing: 10) {
                    GameQuestionView()
                    GameStackView()
                    SwipeActionButtonsView()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .onAppear {
                    if appService.gameService.level == 0 {
                        appService.gameService.nextQuiz()
                    }
                }
            case .finish:
                VStack {
                    Text("Total: \(appService.gameService.totalPoints)/\(GameConfig.numberOfQuizzes * GameConfig.secondsPerQuiz)")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.blue)
                        .padding()
                    Button {
                        appService.gameService.on(.refreshGame)
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
            GameCheckView(points: appService.gameService.newPoints,
                          flag: .constant(appService.gameService.answerFeedback))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.all)
            GameCountDownView()
        }
    }
}

struct GameCountDownView: View {
    @Environment(AppService.self) private var vm

    var body: some View {
        if vm.gameService.showCountdown {
            Text(String(vm.gameService.timeRemaining))
                .font(.system(size: 200))
                .fontWeight(.medium)
                .foregroundStyle(Color.blue.gradient)
                .opacity(0.6)
                .padding()
                .allowsHitTesting(false)
        }
    }
}

struct GamePlayingView: View {
    var body: some View {
        Text("")
    }
}

struct GameQuestionView: View {
    @Environment(\.screenSize) var screenSize
    @Environment(AppService.self) private var vm

    var body: some View {
        Text(vm.gameService.questionTyping)
            .font(.title2)
            .fontWeight(.heavy)
            .foregroundStyle(Color.blue.gradient)
            .padding()
            .frame(height: screenSize.height * GameConfig.questionHeightScale)
            .minimumScaleFactor(0.5)
    }
}

struct GameCardView: View {
    @Environment(\.screenSize) var screenSize
    @Environment(AppService.self) private var vm
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = 0
    @State private var degrees: Double = 0
    let movie: Media
    let answer: Bool?
    
    var body: some View {
        ZStack {
            ZStack (alignment: .top) {
                CacheAsyncImage(url: movie.imageUrl) { phase in
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
                            EmptyPosterView(text: movie.name)
                        }
                    @unknown default: EmptyView()
                    }
                }
                SwipeActionIndicatorView(xOffset: $xOffset)
            }
        }
        .onChange(of: vm.gameService.buttonSwipeAction) {
            onReceiveSwipeAction()
        }
        .aspectRatio(2/3, contentMode: .fit)
        .containerRelativeFrame(.horizontal) { length, _ in
            length * GameConfig.quizWidhtScale
        }
        .cornerRadius(10)
        .shadow(radius: 4, y: 4)
        .padding()
        .offset(x: xOffset, y: yOffset)
        .rotationEffect(.degrees(degrees))
        .gesture(DragGesture()
            .onChanged(onDragChanged)
            .onEnded(onDragEnded))
    }
}

private extension GameCardView {
    func returnToCenter() {
        xOffset = .zero
        yOffset = .zero
        degrees = .zero
    }
    
    func swipeRight() {
        xOffset = screenSize.width
        degrees = GameConfig.quizCardDegrees
    }
    
    func swipeLeft() {
        xOffset = -screenSize.width
        degrees = -GameConfig.quizCardDegrees
    }
    
    func swipeDown() {
        yOffset = screenSize.height
        if let randomDegree = GameConfig.swipeDownDegrees.randomElement() {
            degrees = randomDegree
        }
    }
    
    @MainActor
    func onReceiveSwipeAction() {
        guard let action = vm.gameService.buttonSwipeAction,
              let topCardMovie = vm.gameService.currentQuizzes.first?.movie,
              self.movie.id == topCardMovie.id else { return }
        switch action {
        case .trueAnswer:
            xOffset = 1
            withAnimation (.bouncy(duration: 1)) {
                swipeRight()
            }
        case .falseAnswer:
            xOffset = -1
            withAnimation (.bouncy(duration: 1)) {
                swipeLeft()
            }
        case .noAnswer:
            yOffset = 1
            withAnimation (.bouncy(duration: 1)) {
                swipeDown()
            }
        }
        vm.gameService.on(.onSetSwipeAction(nil))
    }
}

private extension GameCardView {
    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        if value.translation.height > 0 {
            yOffset = value.translation.height
        }
        degrees = Double(value.translation.width / 25)
    }
    
    @MainActor
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        switch value.translation {
        case let translation where abs(translation.width) <= abs(screenSize.width * GameConfig.screenCutoffScale) && abs(translation.height) <= abs(translation.height * GameConfig.screenCutoffScale):
            withAnimation(.bouncy(duration: 1, extraBounce: 0.3)) {
                returnToCenter()
            }
        case let translation where translation.width >= screenSize.width * GameConfig.screenCutoffScale:
            vm.gameService.sendAnswer(gameAnswer: .trueAnswer)
            withAnimation(.bouncy(duration: 0.7)) {
                swipeRight()
            }
            vm.gameService.removeCurrentQuiz(delay: 200000000)
            
        case let translation where translation.width <= -screenSize.width * GameConfig.screenCutoffScale:
            vm.gameService.sendAnswer(gameAnswer: .falseAnswer)
            withAnimation(.bouncy(duration: 0.7)) {
                swipeLeft()
            }
            vm.gameService.removeCurrentQuiz(delay: 200000000)
        case let translation where translation.height >= screenSize.width * GameConfig.screenCutoffScale:
            vm.gameService.sendAnswer(gameAnswer: .noAnswer)
            withAnimation(.bouncy(duration: 0.7)) {
                swipeDown()
            }
            vm.gameService.removeCurrentQuiz(delay: 200000000)
        default:
            withAnimation(.bouncy(duration: 1, extraBounce: 0.3)) {
                returnToCenter()
            }
        }
    }
}

struct SwipeActionIndicatorView: View {
    @Environment(\.screenSize) var screenSize
    @Binding var xOffset: CGFloat
    // TODO: - lack noAnswer tag
    var body: some View {
        HStack {
            ForEach([true, false], id: \.self) { value in
                SwipeActionTagView(
                    text: value ? "hand.thumbsup.circle" : "hand.thumbsdown.circle",
                    color: value ? .green : .red,
                    degrees: value ? -10 : 10,
                    opacity: value ? Double(xOffset / (screenSize.width * GameConfig.screenCutoffScale)) : -Double(xOffset / (screenSize.width * GameConfig.screenCutoffScale)),
                    alignment: value ? .leading : .trailing
                )
            }
        }
        .padding(25)
    }
}

struct SwipeActionTagView: View {
    var text: String
    var color: Color
    var degrees: Double
    var opacity: Double
    var alignment: Alignment
    
    var body: some View {
        Image(systemName: text)
            .foregroundStyle(color)
            .scaleEffect(4)
            .padding()
            .rotationEffect(.degrees(degrees))
            .opacity(opacity)
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

struct GameStackView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(AppService.self) private var vm

    var body: some View {
        if verticalSizeClass == .regular {
            ZStack {
                ForEach(Array(vm.gameService.currentQuizzes.enumerated()), id: \.element.id) { index, quiz in
                    GameCardView(movie: quiz.movie, answer: quiz.quiz.result)
                        .scaleEffect(1 - CGFloat(index) * 0.04)
                        .offset(x: 0, y: CGFloat(index) * -15)
                        .zIndex(Double(vm.gameService.currentQuizzes.count - index))
                        .disabled(index == 0 ? !vm.gameService.isQuizReady : true)
                }
                .animation(.easeInOut(duration: 1.0), value: vm.gameService.currentQuizzes)
            }
        }
    }
}

struct SwipeActionButtonsView: View {
    @Environment(AppService.self) private var vm

    var body: some View {
        HStack (spacing: 15) {
            Text("\(vm.gameService.level)/20")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(Color.blue.gradient)
                .padding()
            ActionButtonView(gameAnswer: .falseAnswer, name: "hand.thumbsdown.fill", color: .red)
            ActionButtonView(gameAnswer: .noAnswer,name: "person.fill.questionmark", color: .blue)
            ActionButtonView(gameAnswer: .trueAnswer, name: "hand.thumbsup.fill", color: .green)
            Text("\(vm.gameService.totalPoints)")
                .font(.title2)
                .fontWeight(.heavy)
                .foregroundStyle(Color.blue.gradient)
                .padding()
        }
        .sensoryFeedback(.increase, trigger: vm.gameService.totalPoints)
    }
}

struct ActionButtonView: View {
    @Environment(AppService.self) private var vm
    var gameAnswer: GameAnswer
    var name: String
    var color: Color
    
    var body: some View {
        
        Button {
            vm.gameService.on(.onSetSwipeAction(gameAnswer))
            vm.gameService.sendAnswer(gameAnswer: gameAnswer)
            vm.gameService.removeCurrentQuiz(delay: 500000000)
        } label: {
            Image(systemName: name)
                .foregroundStyle(color)
                .scaleEffect(1.6)
                .background {
                    Circle()
                        .fill(.white)
                        .frame(width: 64, height: 64)
                        .shadow(radius: 6)
                }
        }
        .frame(width: 64, height: 64)
        .disabled(!vm.gameService.isQuizReady)
    }
}

struct GameCheckView: View {
    var points: Int
    @Binding var flag: Bool
    var body: some View {
        Text(points < 0 ? "\(points)" : "+\(points)")
        //            .font(.system(size: 150))
            .foregroundStyle(points < 0 ? .red : .green)
            .transition(.symbolEffect(.automatic))
            .keyframeAnimator(
                initialValue: AnimationValues(),
                trigger: flag
            ) { content, value in
                content
                    .rotationEffect(value.angle)
                    .font(.system(size: value.size))
                //                    .scaleEffect(value.scale)
                    .scaleEffect(y: value.yStretch)
                    .offset(y: value.yTranslation)
            } keyframes: { _ in
                KeyframeTrack(\.size) {
                    LinearKeyframe(0.0, duration: 0.1)
                    SpringKeyframe(200, duration: 0.3, spring: .bouncy)
                    SpringKeyframe(150, duration: 0.5, spring: .bouncy)
                    LinearKeyframe(1, duration: 0.1)
                }
                //                KeyframeTrack(\.scale) {
                //                    LinearKeyframe(0.0, duration: 0.1)
                //                    SpringKeyframe(16, duration: 0.3, spring: .bouncy)
                //                    SpringKeyframe(12, duration: 0.5, spring: .bouncy)
                //                    LinearKeyframe(1, duration: 0.1)
                //                }
                KeyframeTrack(\.yTranslation) {
                    LinearKeyframe(100.0, duration: 0.2)
                    SpringKeyframe(-300, duration: 0.6, spring: .bouncy)
                    SpringKeyframe(-1000, duration: 0.2, spring: .bouncy)
                }
                KeyframeTrack(\.yStretch) {
                    LinearKeyframe(1, duration: 0.65)
                    CubicKeyframe(0.6, duration: 0.1)
                    CubicKeyframe(1.3, duration: 0.1)
                    LinearKeyframe(1, duration: 0.15)
                }
                KeyframeTrack(\.angle) {
                    //                    CubicKeyframe(Angle(degrees: 45), duration: 0.1)
                    //                    CubicKeyframe(Angle(degrees: -40), duration: 0.1)
                    //                    CubicKeyframe(Angle(degrees: 25), duration: 0.13)
                    //                    CubicKeyframe(Angle(degrees: -20), duration: 0.13)
                    //                    CubicKeyframe(Angle(degrees: 15), duration: 0.16)
                    //                    CubicKeyframe(Angle(degrees: -10), duration: 0.16)
                    //                    CubicKeyframe(Angle(degrees: 5), duration: 0.2)
                    //                    CubicKeyframe(Angle(degrees: 0), duration: 0.2)
                }
            }
    }
}

struct AnimationValues {
    var size = 1.0
    var scale = 1.0
    var yStretch = 1.0
    var yTranslation = 200.0
    var angle = Angle.zero
}

#if DEBUG
#Preview("GameViewTest") {
    GameView()
        .environment(AppService.preview)
}
#endif
