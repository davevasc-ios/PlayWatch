//
//  GameQuizUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

import Foundation

protocol GameQuizUseCaseProtocol {
    func fetchMedia(locale: MovieDB.Locale) async throws -> [Media]
    func fetchQuiz(media: [Media], language: String) async throws -> [Quiz]
}

extension GameQuizUseCaseProtocol {
    func fetchGameQuiz(locale: MovieDB.Locale) async throws -> [GameQuiz] {
        let randomMovieList = try await self.fetchMedia(locale: locale)
        guard randomMovieList.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        let gameQuizList = try await self.fetchQuiz(media: randomMovieList, language: locale.language)
        guard gameQuizList.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        return try self.loadAllQuizzes(media: randomMovieList, quiz: gameQuizList)
    }
    
    private func loadAllQuizzes(media: [Media], quiz: [Quiz]) throws -> [GameQuiz] {
        guard media.count == quiz.count else {
            throw Constants.Game.Error.outOfRange
        }
        var gameQuiz: [GameQuiz] = []
        for index in .zero..<media.count {
            gameQuiz.append(GameQuiz(movie: media[index], quiz: quiz[index]))
        }
        return gameQuiz
    }
}

struct GameQuizUseCase: GameQuizUseCaseProtocol {
    let appServer: Constants.AppServer
    
    func fetchMedia(locale: MovieDB.Locale) async throws -> [Media] {
        let repository: MovieDBRepositoryProtocol = MovieDBRepository(type: .randomMovies, locale: locale)
        return try await repository.fetchMedia().filterWithImage()
    }
    
    func fetchQuiz(media: [Media], language: String) async throws -> [Quiz] {
        switch appServer {
        case .openAI:
            let repository: OpenAIRepositoryProtocol = OpenAIRepository(movies: "", language: language)
            return try await repository.fetchQuiz()
        case .gemini:
            let repository: GeminiRepositoryProtocol = GeminiRepository(movies: "", language: language)
            return try await repository.fetchQuiz()
        }
    }
}

struct GameQuizUseCaseTest: GameQuizUseCaseProtocol {
    
    func fetchMedia(locale: MovieDB.Locale) async throws -> [Media] {
        let repository: MovieDBRepositoryProtocol = MovieDBRepositoryTest(resourceName: Constants.Resource.Name.movies)
        return try await repository.fetchMedia().filterWithImage()
    }
    
    func fetchQuiz(media: [Media], language: String) async throws -> [Quiz] {
        
        let repository: OpenAIRepositoryProtocol = OpenAIRepositoryTest()
        return try await repository.fetchQuiz()
    }
}
