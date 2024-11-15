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
    let mediaRepository: MovieDBRepositoryProtocol
    let gameQuizRepository: MultiAIRepositoryProtocol
    
    internal func fetchMedia(locale: MovieDB.Locale) async throws -> [Media] {
        try await mediaRepository.fetchMedia(resourceName: .empty, type: .randomMovies, locale: locale, searchText: nil).filterWithImage()
    }
    
    internal func fetchQuiz(appServer: Constants.AppServer, media: [Media], language: String) async throws -> [Quiz] {
        try await gameQuizRepository.fetchQuiz(movies: media.joinedNames(), language: language, appServer: appServer)
    }
}

struct GameQuizUseCaseTest: GameQuizUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    let gameQuizRepository: MultiAIRepositoryProtocol

    internal func fetchMedia(locale: MovieDB.Locale) async throws -> [Media] {
        return try await mediaRepository.fetchMedia(resourceName: Constants.Resource.Name.movies, type: .randomMovies, locale: locale, searchText: nil).filterWithImage()
    }
    
    internal func fetchQuiz(appServer: Constants.AppServer, media: [Media], language: String) async throws -> [Quiz] {
//        let repository: MultiAIRepositoryProtocol = MultiAIRepositoryTest()
        return try await gameQuizRepository.fetchQuiz(movies: .empty, language: .empty, appServer: appServer)
    }
}
