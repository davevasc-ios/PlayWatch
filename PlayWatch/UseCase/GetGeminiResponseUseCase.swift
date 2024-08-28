//
//  GetGeminiResponseUseCase.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

protocol GetGeminiResponseProtocol: Sendable {
    func getResponse(prompt: String) async throws -> String
    func getMoviesQuiz(movies: String, language: String) async throws -> [Quiz]
}

struct GetGeminiResponseUseCase: GetGeminiResponseProtocol {
    private let service: GeminiServiceProtocol = GeminiService()
    
    internal func getResponse(prompt: String) async throws -> String {
        return try await service.getResponse(prompt: prompt)
    }
    
    internal func getMoviesQuiz(movies: String, language: String) async throws -> [Quiz] {
        return try await service.moviesQuiz(movies: movies, language: language)
    }
}
