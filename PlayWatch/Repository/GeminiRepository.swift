//
//  GeminiRepository.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

import Foundation

protocol GeminiRepositoryProtocol {
    func createRequest() throws -> URLRequest
}

extension GeminiRepositoryProtocol {
    func fetchQuiz() async throws -> [Quiz] {
        let data = try await self.fetchData(request: self.createRequest())
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
    
    private func fetchData(request: URLRequest) async throws-> Data {
        if let url = request.url, url.isFileURL {
            return try Data(contentsOf: url)
        } else {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == HTTP.successCode else {
                throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
            }
            return data
        }
    }
}

struct GeminiRepository: GeminiRepositoryProtocol {
    let movies: String
    let language: String
    
    internal func createRequest() throws -> URLRequest {
        let prompt = Gemini.quizPrompt(movies: movies, language: language)
        return try Gemini.request(text: prompt)
    }
}

struct GeminiRepositoryTest: GeminiRepositoryProtocol {
    internal func createRequest() throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: Constants.Resource.Name.quizzes, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
