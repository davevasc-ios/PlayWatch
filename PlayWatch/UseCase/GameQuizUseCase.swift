//
//  GameQuizUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

import Foundation

protocol GameQuizUseCaseProtocol {
    func fetchMedia(locale: MovieDB.Locale) async throws -> [Media]
    func fetchQuiz(appServer: Constants.AppServer, media: [Media], language: String) async throws -> [Quiz]
}

extension GameQuizUseCaseProtocol {
    func fetchGameQuiz(appServer: Constants.AppServer, mediaLocale: MovieDB.Locale) async throws -> [GameQuiz] {
        let randomMovieList = try await self.fetchMedia(locale: mediaLocale)
        guard randomMovieList.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        let gameQuizList = try await self.fetchQuiz(appServer: appServer, media: randomMovieList, language: mediaLocale.name)
        guard gameQuizList.count == Constants.Game.numberOfQuizzes else {
            throw Constants.Game.Error.outOfRange
        }
        return try self.loadAllQuizzes(media: randomMovieList, quiz: gameQuizList)
    }
    
    private func loadAllQuizzes(media: [Media], quiz: [Quiz]) throws -> [GameQuiz] {
        guard media.count == quiz.count else {
            throw Constants.Game.Error.outOfRange
        }
        return zip(media, quiz).map { GameQuiz(movie: $0, quiz: $1) }
    }
}

struct GameQuizUseCase: GameQuizUseCaseProtocol {
    internal func fetchMedia(locale: MovieDB.Locale) async throws -> [Media] {
        let repository: MovieDBRepositoryProtocol = MovieDBRepository(type: .randomMovies, locale: locale)
        return try await repository.fetchMedia().filterWithImage()
    }
    
    internal func fetchQuiz(appServer: Constants.AppServer, media: [Media], language: String) async throws -> [Quiz] {
        let repository: MultiAIRepositoryProtocol = MultiAIRepository(movies: media.joinedNames(), language: language)
        return try await repository.fetchQuiz(appServer: appServer)
    }
}

struct GameQuizUseCaseTest: GameQuizUseCaseProtocol {
    
    internal func fetchMedia(locale: MovieDB.Locale) async throws -> [Media] {
        let repository: MovieDBRepositoryProtocol = MovieDBRepositoryTest(resourceName: Constants.Resource.Name.movies)
        return try await repository.fetchMedia().filterWithImage()
    }
    
    internal func fetchQuiz(appServer: Constants.AppServer, media: [Media], language: String) async throws -> [Quiz] {
        let repository: MultiAIRepositoryProtocol = MultiAIRepositoryTest()
        return try await repository.fetchQuiz(appServer: appServer)
    }
}
