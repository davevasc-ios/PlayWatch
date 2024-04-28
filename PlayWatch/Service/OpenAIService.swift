//
//  OpenAIService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

protocol OpenAIServiceProtocol {
    func getResponse(text: String) async throws -> String
    func getQuiz() async throws -> [MovieQuiz]
}

final class OpenAIService: OpenAIServiceProtocol {
    
    func getResponse(text: String) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: OpenAI.request())
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse
        }
        do {
            return try JSONDecoder().decode(OpenAIModel.self, from: data).choices?.first?.message?.content ?? ""
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
    func getQuiz() async throws -> [MovieQuiz] {
        let (data, response) = try await URLSession.shared.data(for: OpenAI.request())
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse
        }
        do {
            let quizString = try JSONDecoder().decode(OpenAIModel.self, from: data).choices?.first?.message?.content ?? ""
            guard let quizData = quizString.data(using: .utf8) else {
                throw API.Error.invalidData
            }
            return try JSONDecoder().decode([MovieQuiz].self, from: quizData)
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
}
