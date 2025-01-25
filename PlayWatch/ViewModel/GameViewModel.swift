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

@Observable
final class GameViewModel: EventHandler {
    
    // MARK: - Public Read-Only Properties
    private(set) var currentQuizzes: [GameQuiz] = []
    private(set) var state: GameStatus = .empty
    private(set) var totalPoints: Int = .zero
    private(set) var newPoints: Int = .zero
    private(set) var isQuizReady = false
    private(set) var buttonSwipeAction: GameAnswer?
    private(set) var nextQuestion: String = .empty
    private(set) var level: Int = 0
    private(set) var answerFeedback = false
    private(set) var timeRemaining: Int = Constants.Game.secondsPerQuiz
    private(set) var showCountdown: Bool = false
    private(set) var questionTyping: String = .empty
    
    // MARK: - Private Properties
    @ObservationIgnored private var countdownTask: Task<Void, Never>?
    @ObservationIgnored private var success = true
    @ObservationIgnored private var allQuizzes: [GameQuiz] = []
    @ObservationIgnored private var locale = MovieDB.Locale()
    @ObservationIgnored private var server: Constants.AIServer = .openAI
    @ObservationIgnored private let gameUseCase: GameUseCaseProtocol
    
    // MARK: - Initialization
    init(gameUseCase: GameUseCaseProtocol = GameUseCase()) {
        self.gameUseCase = gameUseCase
    }
    
    // MARK: - Event Handling
    enum Event {
        case viewAppear(MovieDB.Locale, Constants.AIServer),
             refreshGame,
             cleanGame,
             onSetSwipeAction(GameAnswer?),
             onQuizReady
    }
    
    // MARK: - Public Methods
    func on(_ event: Event) {
        switch event {
        case .viewAppear(let locale, let server):
            self.load(locale: locale, server: server)
        case .refreshGame:
            self.refresh()
        case .cleanGame:
            self.clean()
        case .onSetSwipeAction(let value):
            self.setSwipeAction(value: value)
        case .onQuizReady:
            self.quizReady()
        }
    }
    
    func start() {
        self.state = .playing
    }
    
    // MARK: - Private Methods
    private func clean() {
        self.currentQuizzes.removeAll()
        self.state = .empty
        self.totalPoints = .zero
        self.newPoints = .zero
        self.isQuizReady = false
        self.buttonSwipeAction = nil
        self.nextQuestion = .empty
        self.level = .zero
        self.timeRemaining = Constants.Game.secondsPerQuiz
        self.showCountdown = false
        self.allQuizzes.removeAll()
    }
    
    @MainActor
    private func load(locale: MovieDB.Locale? = nil, server: Constants.AIServer? = nil) {
        if let locale = locale {
            self.locale = locale
        }
        if let server = server {
            self.server = server
        }
        if state == .empty || state == .error {
            self.state = .loading
            Task {
                do {
                    self.allQuizzes = try await self.gameUseCase.fetchGameQuiz(aiServer: self.server, mediaLocale: self.locale)
                    self.updateCurrentQuizzes()
                    self.nextQuestion = self.currentQuizzes.first?.quiz.question ?? .empty
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
    

    @MainActor
    private func refresh() {
        if state != .loading {
            self.clean()
            self.load()
        }
    }
    
    func updateCurrentQuizzes() {
        while self.currentQuizzes.count < 3, self.allQuizzes.count > 0 {
            if let quiz = self.allQuizzes.first {
                self.currentQuizzes.append(quiz)
                self.allQuizzes.removeFirst()
            }
        }
    }
    
    @MainActor
    func removeCurrentQuiz(delay: UInt64) {
        Task {
            try? await Task.sleep(nanoseconds: delay)
            self.currentQuizzes.removeFirst()
            guard self.currentQuizzes.count > .zero else {
                self.state = .finish
                //            self.refresh()
                return
            }
            self.updateCurrentQuizzes()
        }
    }
    
    @MainActor
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

    func setSwipeAction(value: GameAnswer?) {
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
    
    @MainActor
    func quizReady() {
        self.isQuizReady = true
        self.startCountdown()
    }
    
    @MainActor
    func nextQuiz() {
        self.startQuestionTyping()
        self.level += 1
    }
    
    @MainActor
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

    @MainActor
    func startCountdown() {
        self.countdownTask?.cancel()
        self.timeRemaining = Constants.Game.secondsPerQuiz
        self.showCountdown = true
        self.countdownTask = Task {
            while self.timeRemaining >= 0 && self.showCountdown {
                try? await Task.sleep(for: .seconds(1))
                if showCountdown {
                    await MainActor.run {
                        self.timeRemaining -= 1
                    }
                }
            }
            if self.timeRemaining < 0 {
                await MainActor.run {
                    self.setSwipeAction(value: .noAnswer)
                    self.sendAnswer(gameAnswer: .noAnswer)
                    self.removeCurrentQuiz(delay: 700_000_000)
                }
            }
        }
    }
    
    func stopCountdown() {
        self.showCountdown = false
        self.countdownTask?.cancel()
    }
    
}
