//
//  MultiAIRepository.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol MultiAIRepositoryProtocol {
    func createRequest(movies: String, language: String, appServer: Constants.AppServer) throws -> URLRequest
}

extension MultiAIRepositoryProtocol {
    func fetchQuiz(movies: String, language: String, appServer: Constants.AppServer) async throws -> [Quiz] {
        let data = try await self.fetchData(request: self.createRequest(movies: movies, language: language, appServer: appServer))
        do {
            let quizString = switch appServer {
            case .openAI: (try JSONDecoder().decode(OpenAIModel.self, from: data).choices?.first?.message?.content).orEmpty
            case .gemini: (try JSONDecoder().decode(GeminiModel.self, from: data).candidates?.first?.content?.parts?.first?.text).orEmpty
            }
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

struct MultiAIRepository: MultiAIRepositoryProtocol {
    internal func createRequest(movies: String, language: String, appServer: Constants.AppServer) throws -> URLRequest {
        switch appServer {
        case .openAI:
            let prompt = OpenAI.UserPrompt.quiz(movies, language)
            return try OpenAI.request(type: prompt)
        case .gemini:
            let prompt = Gemini.quizPrompt(movies, language)
            return try Gemini.request(text: prompt)
        }
    }
}

struct MultiAIRepositoryTest: MultiAIRepositoryProtocol {
    internal func createRequest(movies: String, language: String, appServer: Constants.AppServer) throws -> URLRequest {
        let resource = switch appServer {
        case .openAI: Constants.Resource.Name.openAIResponse
        case .gemini: Constants.Resource.Name.geminiAIResponse
        }
        guard let url = Bundle.main.url(forResource: resource, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
