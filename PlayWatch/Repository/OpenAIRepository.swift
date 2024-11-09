//
//  OpenAIRepository.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

import Foundation

protocol OpenAIRepositoryProtocol {
    func createRequest() throws -> URLRequest
}

extension OpenAIRepositoryProtocol {
    func fetchQuiz() async throws -> [Quiz] {
        let data = try await self.fetchData(request: self.createRequest())
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

struct OpenAIRepository: OpenAIRepositoryProtocol {
    let movies: String
    let language: String
    
    internal func createRequest() throws -> URLRequest {
        let userPrompt = OpenAI.UserPrompt.quiz(movies, language)
        return try OpenAI.request(type: userPrompt)
    }
}

struct OpenAIRepositoryTest: OpenAIRepositoryProtocol {
    internal func createRequest() throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: Constants.Resource.Name.quizzes, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
