//
//  GetOpenAIResponseUseCase.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

protocol GetOpenAIResponseProtocol {
    func getTextAnswer(prompt: String) async throws -> String
    func getMoviesQuiz(movies: String) async throws -> [MovieQuiz]
}
struct GetOpenAIResponseUseCase: GetOpenAIResponseProtocol {
    var service: OpenAIServiceProtocol
    
    init(service: OpenAIServiceProtocol = OpenAIService()) {
        self.service = service
    }
    
    func getTextAnswer(prompt: String) async throws -> String {
       return try await service.textAnswer(prompt: prompt)
    }
    
    func getMoviesQuiz(movies: String) async throws -> [MovieQuiz] {
        return try await service.moviesQuiz(movies: movies)
    }
    
}
