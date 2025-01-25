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
}

extension GameUseCaseProtocol {
    func fetchGameQuiz(aiServer: Constants.AIServer, mediaLocale: MovieDB.Locale) async throws -> [GameQuiz] {
        let mediaConfig = MediaRequestConfig(mediaType: .randomMovies, locale: mediaLocale)
        let randomMovies = try await self.mediaRepository.fetchMedia(config: mediaConfig).filterWithImage()
        guard randomMovies.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        let gameConfig = GameRequestConfig(movies: randomMovies.joinedNames(), language: mediaLocale.name, aiServer: aiServer)
        let gameQuizzes = try await self.gameRepository.fetchQuiz(config: gameConfig)
        guard gameQuizzes.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        return zip(randomMovies, gameQuizzes).map { GameQuiz(movie: $0, quiz: $1) }
    }
}

struct GameUseCase: GameUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    let gameRepository: MultiAIRepositoryProtocol
    
    init(mediaRepository: MovieDBRepositoryProtocol = MovieDBRepository(),
         gameRepository: MultiAIRepositoryProtocol = MultiAIRepository()) {
        self.mediaRepository = mediaRepository
        self.gameRepository = gameRepository
    }
}
