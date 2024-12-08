//
//  MultiAIRepository.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol MultiAIRepositoryProtocol {
    var repositoryType: RepositoryType { get }
}

extension MultiAIRepositoryProtocol {
    func fetchQuiz(movies: String, language: String, appServer: Constants.AppServer) async throws -> [Quiz] {
        let request = try self.createRequest(movies: movies, language: language, appServer: appServer)
        let data = try await request.fetchData()
        do {
            let quizString = switch appServer {
            case .openAI: try OpenAIModel.decode(from: data)
            case .gemini: try GeminiModel.decode(from: data)
            }
            guard let quizData = quizString.toUTF8Data else {
                throw API.Error.invalidData(detail: quizString)
            }
            return try Quiz.decode(from: quizData)
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
    
    private func createRequest(movies: String, language: String, appServer: Constants.AppServer) throws -> URLRequest {
        switch self.repositoryType {
        case .live:
            appServer == .openAI ?
            try OpenAI.request(type: OpenAI.UserPrompt.quiz(movies, language)) :
            try Gemini.request(text: Gemini.quizPrompt(movies, language))
        case .test:
            try Bundle.main.jsonURLRequest(forResource: appServer.testResource)
        }
    }
}

enum MultiAIRepository: MultiAIRepositoryProtocol {
    case live, test
    
    var repositoryType: RepositoryType {
        self == .test ? .test : .live
    }
}
