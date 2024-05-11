//
//  GameViewModel.swift
//  PlayWatch
//
//  Created by David on 28/4/24.
//

import Observation

enum GameViewAction {
    case onAppear(MovieDB.Locale),
         onRefresh,
         onClean
}

@Observable
final class GameViewModel {
    private(set) var mediaList: [Media] = []
    private(set) var quizList: [MovieQuiz]  = []
    private(set) var state: API.Status = .empty
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
            self.start(locale: locale)
        case .onRefresh:
            self.refresh()
        case .onClean:
            self.clean()
        }
    }
    
    private func start(locale: MovieDB.Locale? = nil) {
        if let locale = locale {
            self.locale = locale
        }
        if state == .empty || state == .error {
            self.state = .loading
            Task {
                do {
                    self.mediaList = try await self.fetchMediaUseCase.fetchMedia(type: .randomMovies, locale: self.locale, searchText: nil).filterWithImage()
                    self.quizList = try await self.getOpenAIUseCase.getMoviesQuiz(movies: self.mediaList.map { $0.mediaName }.joined(separator: ", "), language: self.locale.name)
                    self.state = .success
                }
                catch {
                    print(error.localizedDescription)
                    self.state = .error
                }
            }
        }
    }
    
    private func clean() {
        self.mediaList.removeAll()
        self.quizList.removeAll()
        self.state = .empty
    }
    
    private func refresh() {
        if state != .loading {
            self.clean()
            self.start()
        }
    }
}
