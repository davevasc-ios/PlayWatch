//
//  GeminiService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

protocol GeminiServiceProtocol {
    func getResponse(prompt: String) async throws -> String
    func moviesQuiz(movies: String, language: String) async throws -> [Quiz]
}

final class GeminiService: GeminiServiceProtocol {
    
    func getResponse(prompt: String) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: Gemini.request(text: prompt))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
        }
        do {
            return try JSONDecoder().decode(GeminiModel.self, from: data).candidates?.first?.content?.parts?.first?.text ?? ""
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
    
    func moviesQuiz(movies: String, language: String) async throws -> [Quiz] {
        let (data, response) = try await URLSession.shared.data(for: Gemini.request(text: Gemini.quizPrompt(movies: movies, language: language)))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
        }
        do {
            let quizString = try JSONDecoder().decode(GeminiModel.self, from: data).candidates?.first?.content?.parts?.first?.text ?? ""
            guard let quizData = quizString.data(using: .utf8) else {
                throw API.Error.invalidData(detail: quizString)
            }
            return try JSONDecoder().decode([Quiz].self, from: quizData)
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}
