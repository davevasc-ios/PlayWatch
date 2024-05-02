//
//  OpenAIService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

protocol OpenAIServiceProtocol {
    func textAnswer(prompt: String) async throws -> String
    func moviesQuiz(movies: String) async throws -> [MovieQuiz]
}

final class OpenAIService: OpenAIServiceProtocol {
    
    func textAnswer(prompt: String) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: OpenAI.request(type: OpenAI.UserPrompt.text(prompt)))
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
    func moviesQuiz(movies: String) async throws -> [MovieQuiz] {
        let (data, response) = try await URLSession.shared.data(for: OpenAI.request(type: OpenAI.UserPrompt.quiz(movies)))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
        }
        do {
            let quizString = try JSONDecoder().decode(OpenAIModel.self, from: data).choices?.first?.message?.content ?? ""
            guard let quizData = quizString.data(using: .utf8) else {
                throw API.Error.invalidData(detail: quizString)
            }
            return try JSONDecoder().decode([MovieQuiz].self, from: quizData)
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}
