//
//  QuizRepository.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol QuizRepositoryProtocol: Sendable {
    func fetchQuiz(for movies: String, using server: AIServer, in language: String) async throws -> [Quiz]
}

extension QuizRepositoryProtocol {
//    func fetchQuiz(for movies: String, using server: AIServer, in language: String) async throws -> [Quiz] {
//        try await self.fetchQuiz(for: movies, using: server, in: language)
//    }
}

struct QuizRepository: QuizRepositoryProtocol {
    let aiRequestProvider: AIRequestProviding
    
    func fetchQuiz(for movies: String, using server: AIServer, in language: String) async throws -> [Quiz] {
        let request = try await createRequest(for: movies, using: server, in: language)
        let data = try await request.fetchData()
        let decoder = AIResponseDecoderFactory.decoder(for: server)
        let quizString = try decoder.decode(from: data)
        let quizData = try quizString.toUTF8Data()
        return try Quiz.decode(from: quizData)
    }
    
    private func createRequest(for movies: String, using server: AIServer, in language: String) async throws -> URLRequest {
        let prompt = PromptType.quiz(movies: movies, language: language)
        return try await aiRequestProvider.createRequest(for: server, with: prompt)
    }
}
