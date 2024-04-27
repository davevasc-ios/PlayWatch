//
//  GeminiService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

protocol GeminiServiceProtocol {
    func getResponse(text: String) async throws -> String
}

final class GeminiService: GeminiServiceProtocol {

    func getResponse(text: String) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: Gemini.request(text: text))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse
        }
        do {
            return try JSONDecoder().decode(GeminiModel.self, from: data).candidates?.first?.content?.parts?.first?.text ?? ""
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
}
