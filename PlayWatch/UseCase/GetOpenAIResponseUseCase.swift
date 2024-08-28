//
//  GetOpenAIResponseUseCase.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

protocol GetOpenAIResponseProtocol: Sendable {
    func getTextAnswer(prompt: String) async throws -> String
    func getMoviesQuiz(movies: String, language: String) async throws -> [Quiz]
}

struct GetOpenAIResponseUseCase: GetOpenAIResponseProtocol {
    private let service: OpenAIServiceProtocol = OpenAIService()
    
    internal func getTextAnswer(prompt: String) async throws -> String {
        return try await service.textAnswer(prompt: prompt)
    }
    
    internal func getMoviesQuiz(movies: String, language: String) async throws -> [Quiz] {
        return try await service.moviesQuiz(movies: movies, language: language)
    }
}
