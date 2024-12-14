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
        let randomMovies = try await self.mediaRepository.fetchMedia(type: .randomMovies, locale: mediaLocale).filterWithImage()
        guard randomMovies.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        let gameQuizzes = try await self.gameRepository.fetchQuiz(movies: randomMovies.joinedNames(), language: mediaLocale.name, aiServer: aiServer)
        guard gameQuizzes.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        return zip(randomMovies, gameQuizzes).map { GameQuiz(movie: $0, quiz: $1) }
    }
}

struct GameUseCase: GameUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    let gameRepository: MultiAIRepositoryProtocol
}
