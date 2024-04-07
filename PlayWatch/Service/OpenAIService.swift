//
//  OpenAIService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

protocol OpenAIServiceProtocol {
    func getResponse(text: String) async throws -> String
}

final class OpenAIService: OpenAIServiceProtocol {
    
    func getResponse(text: String) async throws -> String {
        let (data, response) = try await URLSession.shared.data(for: OpenAI.request(text: text))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.Code.success else {
            throw API.Error.invalidResponse
        }
        do {
            return try JSONDecoder().decode(OpenAIModel.self, from: data).choices?.first?.message?.content ?? ""
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
}
