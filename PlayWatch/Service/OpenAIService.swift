//
//  OpenAIService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

protocol OpenAIServiceProtocol: Sendable {
    func textAnswer(prompt: String) async throws -> String
    func moviesQuiz(movies: String, language: String) async throws -> [Quiz]
}

final class OpenAIService: OpenAIServiceProtocol {
    
    internal func textAnswer(prompt: String) async throws -> String {
        let (data, response) = try await URLSession.shared.data(request: OpenAI.request(type: OpenAI.UserPrompt.text(prompt)))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
        }
        do {
            return try JSONDecoder().decode(OpenAIModel.self, from: data).choices?.first?.message?.content ?? ""
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
    
    internal func moviesQuiz(movies: String, language: String) async throws -> [Quiz] {
        let (data, response) = try await URLSession.shared.data(request: OpenAI.request(type: OpenAI.UserPrompt.quiz(movies, language)))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
        }
        do {
            let quizString = try JSONDecoder().decode(OpenAIModel.self, from: data).choices?.first?.message?.content ?? ""
            guard let quizData = quizString.data(using: .utf8) else {
                throw API.Error.invalidData(detail: quizString)
            }
            return try JSONDecoder().decode([Quiz].self, from: quizData)
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}
