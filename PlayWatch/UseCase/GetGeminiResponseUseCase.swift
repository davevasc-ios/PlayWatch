//
//  GetGeminiResponseUseCase.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

import Foundation

protocol GetGeminiResponseProtocol {
    func getResponse(prompt: String) async throws -> String
    func getMoviesQuiz(movies: String, language: String) async throws -> [Quiz]
}
struct GetGeminiResponseUseCase: GetGeminiResponseProtocol {
    var service: GeminiServiceProtocol
    
    init(service: GeminiServiceProtocol = GeminiService()) {
        self.service = service
    }
    
    func getResponse(prompt: String) async throws -> String {
        return try await service.getResponse(prompt: prompt)
   
    }
    
    func getMoviesQuiz(movies: String, language: String) async throws -> [Quiz] {
        return try await service.moviesQuiz(movies: movies, language: language)
    }
    
}
