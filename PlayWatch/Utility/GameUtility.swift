//
//  GameUtility.swift
//  PlayWatch
//
//  Created by David on 2/9/25.
//

import Foundation

protocol GameUtilityProtocol {
    var movieDBUtility: MediaUtilityProtocol { get }
    var quizUtility: QuizUtilityProtocol { get }
}

extension GameUtilityProtocol {
    
    func fetchGameQuiz() async throws -> [GameQuiz] {
        let randomMovies = try await movieDBUtility.fetchMedia(mediaType: .randomMovies).filterWithImage
        guard randomMovies.count == GameConfig.numberOfQuizzes else {
            throw GameError.outOfRange
        }
        let gameQuizzes = try await self.quizUtility.fetchQuiz(movies: randomMovies.joinedNames())
        guard gameQuizzes.count == GameConfig.numberOfQuizzes else {
            throw GameError.outOfRange
        }
        return zip(randomMovies, gameQuizzes).map { GameQuiz(movie: $0, quiz: $1) }
    }
}

struct GameUtility: GameUtilityProtocol {
    let movieDBUtility: MediaUtilityProtocol
    let quizUtility: QuizUtilityProtocol
}
