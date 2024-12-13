//
//  GameQuizUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

import Foundation

protocol GameQuizUseCaseProtocol {
    var mediaRepository: MovieDBRepositoryProtocol { get }
    var gameQuizRepository: MultiAIRepositoryProtocol { get }
}

extension GameQuizUseCaseProtocol {
    func fetchGameQuiz(aiServer: Constants.AIServer, mediaLocale: MovieDB.Locale) async throws -> [GameQuiz] {
        let randomMovies = try await self.mediaRepository.fetchMedia(type: .randomMovies, locale: mediaLocale).filterWithImage()
        guard randomMovies.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        let gameQuizzes = try await self.gameQuizRepository.fetchQuiz(movies: randomMovies.joinedNames(), language: mediaLocale.name, aiServer: aiServer)
        guard gameQuizzes.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        return zip(randomMovies, gameQuizzes).map { GameQuiz(movie: $0, quiz: $1) }
    }
}

struct GameQuizUseCase: GameQuizUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    let gameQuizRepository: MultiAIRepositoryProtocol
}
