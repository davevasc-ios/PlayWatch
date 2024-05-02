//
//  GeminiService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

protocol GeminiServiceProtocol {
    func getResponse(prompt: String) async throws -> String
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
}
