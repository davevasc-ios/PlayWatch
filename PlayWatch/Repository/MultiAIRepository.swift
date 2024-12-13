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
        do {
            let quizString = try aiServer.decodeQuizResponse(from: data)
            guard let quizData = quizString.toUTF8Data else {
                throw API.Error.invalidData(detail: quizString)
            }
            return try Quiz.decode(from: quizData)
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}

enum MultiAIRepository: MultiAIRepositoryProtocol {
    case live, test
    
    var mode: RepositoryMode {
        self == .live ? .live : .test
    }
}
