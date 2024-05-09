//
//  GameViewModel.swift
//  PlayWatch
//
//  Created by David on 28/4/24.
//

import Foundation
import Observation

@Observable
final class GameViewModel {
    
    private(set) var mediaList: [Media] = []
    private(set) var quizList: [MovieQuiz]  = []
    private(set) var state: API.Status = .empty
    
    
    // MARK: - Internal vars
    private let fetchMediaUseCase: FetchMediaProtocol
    private let getOpenAIUseCase: GetOpenAIResponseProtocol
    
    // MARK: - Initialization
    init(fetchMediaUseCase: FetchMediaProtocol = FetchMediaUseCase(),
         getOpenAIUseCase: GetOpenAIResponseProtocol = GetOpenAIResponseUseCase()) {
        self.fetchMediaUseCase = fetchMediaUseCase
        self.getOpenAIUseCase = getOpenAIUseCase
    }
    
    func start(locale: MovieDB.Locale) async throws {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                self.state = .loading
                do {
                    self.mediaList = try await self.fetchMediaUseCase.fetchMedia(type: .randomMovies, locale: locale, searchText: nil).filterWithImage()
                    self.quizList = try await self.getOpenAIUseCase.getMoviesQuiz(movies: self.mediaList.map { $0.mediaName }.joined(separator: ", "), language: locale.name)
                    self.state = .success
                }
                catch {
                    print(error.localizedDescription)
                    self.state = .error
                }
            }
        }
    }
    
    func clean() {
        self.mediaList.removeAll()
        self.quizList.removeAll()
        self.state = .empty
    }
    
    func refresh(locale: MovieDB.Locale) async throws {
        self.clean()
        try? await self.start(locale: locale)
    }


    
}
