//
//  GameUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

import Foundation

protocol GameUseCaseProtocol {
    
    var mediaRepository: MovieDBRepositoryProtocol { get }
    var gameRepository: MultiAIRepositoryProtocol { get }
    var storageUtility: StorageUtility { get }
}

extension GameUseCaseProtocol {
    
    func fetchGameQuiz() async throws -> [GameQuiz] {
        let settings = try await self.storageUtility.loadAll()
        let mediaConfig = MediaRequestConfig(mediaType: .randomMovies, locale: settings.mediaLocale)
        let randomMovies = try await self.mediaRepository.fetchMedia(config: mediaConfig).filterWithImage()
        guard randomMovies.count == GameConfig.numberOfQuizzes else {
            throw GameError.outOfRange
        }
        let gameConfig = GameRequestConfig(movies: randomMovies.joinedNames(), language: settings.mediaLocale.name, aiServer: settings.server)
        let gameQuizzes = try await self.gameRepository.fetchQuiz(config: gameConfig)
        guard gameQuizzes.count == GameConfig.numberOfQuizzes else {
            throw GameError.outOfRange
        }
        return zip(randomMovies, gameQuizzes).map { GameQuiz(movie: $0, quiz: $1) }
    }
}

struct GameUseCase: GameUseCaseProtocol {
    
    let mediaRepository: MovieDBRepositoryProtocol
    let gameRepository: MultiAIRepositoryProtocol
    let storageUtility: StorageUtility
    
    init(mediaRepository: MovieDBRepositoryProtocol = MovieDBRepository(),
         gameRepository: MultiAIRepositoryProtocol = MultiAIRepository(),
         storageUtility: StorageUtility) {
        self.mediaRepository = mediaRepository
        self.gameRepository = gameRepository
        self.storageUtility = storageUtility
    }
}
