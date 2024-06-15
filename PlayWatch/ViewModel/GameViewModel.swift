//
//  GameViewModel.swift
//  PlayWatch
//
//  Created by David on 28/4/24.
//

import Observation

enum GameAnswer {
    case trueAnswer, falseAnswer, noAnswer
}

enum GameStatus {
    case empty, loading, ready, playing, finish, error
}

enum GameViewAction {
    case onAppear(MovieDB.Locale),
         onRefresh,
         onClean,
         onSetSwipeAction(Bool?),
         onQuizReady
}

@Observable
final class GameViewModel {
    private(set) var currentQuizzes: [GameQuiz] = []
    private(set) var state: GameStatus = .empty
    private(set) var totalPoints: Int = .zero
    private(set) var newPoints: Int = .zero
    private(set) var isQuizReady = false
    private(set) var buttonSwipeAction: Bool?
    private(set) var nextQuestion: String = .empty
    private(set) var level: Int = 0
    private(set) var answerFeedback = false
    private(set) var timeRemaining: Int = Constants.Game.secondsPerQuiz
    private(set) var showCountdown: Bool = false
    private(set) var questionTyping: String = .empty
    private var countdownTask: Task<Void, Never>? = nil
    private var success = true
    private var allQuizzes: [GameQuiz] = []
    private var locale = MovieDB.Locale()
    
    // MARK: - Internal vars
    private let fetchMediaUseCase: FetchMediaProtocol
    private let getOpenAIUseCase: GetOpenAIResponseProtocol
    
    // MARK: - Initialization
    init(fetchMediaUseCase: FetchMediaProtocol = FetchMediaUseCase(),
         getOpenAIUseCase: GetOpenAIResponseProtocol = GetOpenAIResponseUseCase()) {
        self.fetchMediaUseCase = fetchMediaUseCase
        self.getOpenAIUseCase = getOpenAIUseCase
    }
    
    private func clean() {
        self.currentQuizzes.removeAll()
        self.state = .empty
        self.totalPoints = .zero
        self.newPoints = .zero
        self.isQuizReady = false
        self.buttonSwipeAction = nil
        self.nextQuestion = .empty
        self.level = 0
        self.timeRemaining = Constants.Game.secondsPerQuiz
        self.showCountdown = false
        self.allQuizzes.removeAll()
    }
    
    func action(_ on: GameViewAction) {
        switch on {
        case .onAppear(let locale):
            self.load(locale: locale)
        case .onRefresh:
            self.refresh()
        case .onClean:
            self.clean()
        case .onSetSwipeAction(let value):
            self.setSwipeAction(value: value)
        case .onQuizReady:
            self.quizReady()
        }
    }
    
    private func load(locale: MovieDB.Locale? = nil) {
        if let locale = locale {
            self.locale = locale
        }
        if state == .empty || state == .error {
            self.state = .loading
            Task {
                do {
                    let mediaList = try await self.fetchMediaUseCase.fetchMedia(type: .randomMovies, locale: self.locale, searchText: nil).filterWithImage()
                    let quizList = try await self.getOpenAIUseCase.getMoviesQuiz(movies: mediaList.map { $0.mediaName }.joined(separator: ", "), language: self.locale.name)
                    self.allQuizzes = try self.loadAllQuizzes(media: mediaList, quiz: quizList)
                    self.updateCurrentQuizzes()
                    self.nextQuestion = self.currentQuizzes.first?.quiz.question ?? ""
                    self.state = .ready
                }
                catch Constants.Game.Error.outOfRange {
                    self.state = .error
                    self.refresh()
                }
                catch {
                    self.state = .error
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func start() {
        self.state = .playing
    }
    
    private func refresh() {
        if state != .loading {
            self.clean()
            self.load()
        }
    }
    
    private func loadAllQuizzes(media: [Media], quiz: [Quiz]) throws -> [GameQuiz] {
        guard media.count == Constants.Game.numberOfQuizzes,
              quiz.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        var gameQuiz: [GameQuiz] = []
        for index in .zero..<Constants.Game.numberOfQuizzes {
            gameQuiz.append(GameQuiz(movie: media[index], quiz: quiz[index]))
        }
        return gameQuiz
    }
    
    func updateCurrentQuizzes() {
        while self.currentQuizzes.count < 3, self.allQuizzes.count > 0 {
            if let quiz = self.allQuizzes.first {
                self.currentQuizzes.append(quiz)
                self.allQuizzes.removeFirst()
            }
        }
    }
    
    func removeCurrentQuiz() {
        self.currentQuizzes.removeFirst()
        guard self.currentQuizzes.count > .zero else {
            self.state = .finish
//            self.refresh()
            return
        }
        self.updateCurrentQuizzes()
    }
    
    func sendAnswer(gameAnswer: GameAnswer) {
        self.stopCountdown()
        self.newPoints = .zero
        let result = (self.currentQuizzes.first?.quiz.result).orTrue
        self.getNextQuestion()
        self.isQuizReady = false
        
        if gameAnswer == .noAnswer {
            self.success = false
            self.newPoints = -1
        } else {
            self.success = (gameAnswer == .trueAnswer && result) || (gameAnswer == .falseAnswer && !result)
            self.newPoints = self.success ? self.timeRemaining : -2
        }
        
        self.totalPoints = self.totalPoints + self.newPoints < 0 ? 0 : self.totalPoints + self.newPoints
        self.answerFeedback = !self.answerFeedback
        
        guard self.level < Constants.Game.numberOfQuizzes else { return }
        self.nextQuiz()
    }

    func setSwipeAction(value: Bool?) {
        self.buttonSwipeAction = value
    }
    
    func getNextQuestion() {
        guard currentQuizzes.count > 1,
              let question = self.currentQuizzes[1].quiz.question else {
            self.nextQuestion = .empty
            return
        }
        self.nextQuestion = question
    }
    
    func quizReady() {
        self.isQuizReady = true
        self.startCountdown()
    }
    
    func nextQuiz() {
        self.startQuestionTyping()
        self.level += 1
    }
    
    func startQuestionTyping() {
        self.questionTyping = .empty
        Task {
            for character in self.nextQuestion {
                await MainActor.run {
                    self.questionTyping.append(character)
                }
                try? await Task.sleep(nanoseconds: Constants.Game.typingTextIntervales.randomElement() ?? 50000000)
            }
            await MainActor.run {
                self.quizReady()
            }
        }
    }

    func startCountdown() {
        self.countdownTask?.cancel()
        self.timeRemaining = Constants.Game.secondsPerQuiz
        self.showCountdown = true
        self.countdownTask = Task {
            while self.timeRemaining >= 0 && self.showCountdown {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if showCountdown {
                    await MainActor.run {
                        self.timeRemaining -= 1
                    }
                }
            }
            if self.timeRemaining < 0 {
                await MainActor.run {
                    self.sendAnswer(gameAnswer: .noAnswer)
                    self.removeCurrentQuiz()
                }
            }
        }
    }
    
    func stopCountdown() {
        self.showCountdown = false
        self.countdownTask?.cancel()
    }
    
}
