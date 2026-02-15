//
//  GameUtility.swift
//  PlayWatch
//
//  Created by David on 2/9/25.
//

import Foundation

protocol GameUtilityProtocol {
    var mediaRepository: MediaRepositoryProtocol { get }
    var quizRepository: QuizRepositoryProtocol { get }
}

extension GameUtilityProtocol {
    
    func fetchGameQuiz(for data: GameData) async throws -> [GameQuiz] {
        let randomMovies = try await mediaRepository.fetchMedia(for: .randomMovies, with: data.mediaLocale, searchQuery: nil).filterWithImage
        guard randomMovies.count == GameConfig.numberOfQuizzes else {
            throw GameError.outOfRange
        }
        let gameQuizzes = try await self.quizRepository.fetchQuiz(for: randomMovies.joinedNames(), using: data.server, in: data.language)
        guard gameQuizzes.count == GameConfig.numberOfQuizzes else {
            throw GameError.outOfRange
        }
        return zip(randomMovies, gameQuizzes).map { GameQuiz(movie: $0, quiz: $1) }
    }
}

struct GameUtility: GameUtilityProtocol {
    let mediaRepository: MediaRepositoryProtocol
    let quizRepository: QuizRepositoryProtocol
}
