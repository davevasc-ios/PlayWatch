//
//  MultiAIRepository.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol MultiAIRepositoryProtocol {
    func createRequest(config: GameRequestConfig) throws -> URLRequest
}

extension MultiAIRepositoryProtocol {
    func fetchQuiz(config: GameRequestConfig) async throws -> [Quiz] {
        let request = try self.createRequest(config: config)
        let data = try await request.fetchData()
        let quizString = try config.aiServer.decodeQuizResponse(from: data)
        let quizData = try quizString.toUTF8Data()
        return try Quiz.decode(from: quizData)
    }
}

struct MultiAIRepository: MultiAIRepositoryProtocol {
    func createRequest(config: GameRequestConfig) throws -> URLRequest {
        switch config.aiServer {
        case .openAI: try OpenAI.request(type: OpenAI.UserPrompt.quiz(config.movies, config.language))
        case .gemini: try Gemini.request(text: Gemini.quizPrompt(config.movies, config.language))
        }
    }
}
