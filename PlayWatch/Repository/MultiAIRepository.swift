//
//  MultiAIRepository.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol MultiAIRepositoryProtocol {
    func createRequest(appServer: Constants.AppServer) throws -> URLRequest
}

extension MultiAIRepositoryProtocol {
    func fetchQuiz(appServer: Constants.AppServer) async throws -> [Quiz] {
        let data = try await self.fetchData(request: self.createRequest(appServer: appServer))
        do {
            let quizString = try self.decodeData(appServer: appServer, data: data)
            guard let quizData = quizString.data(using: .utf8) else {
                throw API.Error.invalidData(detail: quizString)
            }
            return try JSONDecoder().decode([Quiz].self, from: quizData)
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
    
    private func decodeData(appServer: Constants.AppServer, data: Data) throws -> String {
        switch appServer {
        case .openAI: try JSONDecoder().decode(OpenAIModel.self, from: data).choices?.first?.message?.content ?? ""
        case .gemini: try JSONDecoder().decode(GeminiModel.self, from: data).candidates?.first?.content?.parts?.first?.text ?? ""
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
    let movies: String
    let language: String
    
    internal func createRequest(appServer: Constants.AppServer) throws -> URLRequest {
        switch appServer {
        case .openAI:
            let userPrompt = OpenAI.UserPrompt.quiz(self.movies, self.language)
            return try OpenAI.request(type: userPrompt)
        case .gemini:
            let prompt = Gemini.quizPrompt(movies: self.movies, language: self.language)
            return try Gemini.request(text: prompt)
        }
    }
}

struct MultiAIRepositoryTest: MultiAIRepositoryProtocol {
    internal func createRequest(appServer: Constants.AppServer) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: Constants.Resource.Name.quizzes, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
