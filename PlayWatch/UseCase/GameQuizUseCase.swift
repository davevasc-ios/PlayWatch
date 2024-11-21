//
//  GameQuizUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

import Foundation

protocol GameQuizUseCaseProtocol {
    var mediaRepo: MovieDBRepositoryProtocol { get }
    var gameQuizRepo: MultiAIRepositoryProtocol { get }
}

extension GameQuizUseCaseProtocol {
    func fetchGameQuiz(appServer: Constants.AppServer, mediaLocale: MovieDB.Locale) async throws -> [GameQuiz] {
        let randomMovies = try await self.mediaRepo.fetchMedia(type: .randomMovies, locale: mediaLocale).filterWithImage()
        guard randomMovies.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        let gameQuizzes = try await self.gameQuizRepo.fetchQuiz(movies: randomMovies.joinedNames(), language: mediaLocale.name, appServer: appServer)
        guard gameQuizzes.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        return zip(randomMovies, gameQuizzes).map { GameQuiz(movie: $0, quiz: $1) }
    }
}

struct GameQuizUseCase: GameQuizUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    let gameQuizRepository: MultiAIRepositoryProtocol
    
    var mediaRepo: MovieDBRepositoryProtocol {
        self.mediaRepository
    }
    var gameQuizRepo: MultiAIRepositoryProtocol {
        self.gameQuizRepository
    }
}
