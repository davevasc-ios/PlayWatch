//
//  MultiAIRepository.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol MultiAIRepositoryProtocol {
    var mode: RepositoryMode { get }
}

extension MultiAIRepositoryProtocol {
    func fetchQuiz(movies: String, language: String, aiServer: Constants.AIServer) async throws -> [Quiz] {
        let request = try aiServer.createRequest(mode: mode, movies: movies, language: language)
        let data = try await request.fetchData()
        let quizString = try aiServer.decodeQuizResponse(from: data)
        let quizData = try quizString.toUTF8Data()
        return try Quiz.decode(from: quizData)
    }
}

struct MultiAIRepository: MultiAIRepositoryProtocol {
    var mode: RepositoryMode = .live
}
