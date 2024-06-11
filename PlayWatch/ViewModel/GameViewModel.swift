//
//  GameViewModel.swift
//  PlayWatch
//
//  Created by David on 28/4/24.
//

import Observation

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
    private(set) var success = true
    private(set) var points: Int = .zero
    private(set) var next = false
    private(set) var disabledCurrentQuiz = true
    private(set) var buttonSwipeAction: Bool?
    private(set) var nextQuestion: String = ""
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
    
    private func clean() {
        self.allQuizzes.removeAll()
        self.currentQuizzes.removeAll()
        self.disabledCurrentQuiz = true
        self.points = .zero
        self.state = .empty
    }
    
    private func loadAllQuizzes(media: [Media], quiz: [Quiz]) throws -> [GameQuiz] {
        guard media.count == Constants.Game.quizCount,
              quiz.count == Constants.Game.quizCount else {
            throw Constants.Game.Error.outOfRange
        }
        var gameQuiz: [GameQuiz] = []
        for index in .zero..<Constants.Game.quizCount {
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
    
    func checkAnswer(value: Bool) {
        self.disabledCurrentQuiz = true
        self.getNextQuestion()
        self.success = value
        self.points += value ? 1 : .zero
        self.next = !self.next
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
        self.disabledCurrentQuiz = false
    }
    
}
