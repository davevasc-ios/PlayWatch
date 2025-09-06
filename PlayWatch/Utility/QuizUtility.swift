//
//  QuizUtility.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol QuizUtilityProtocol {
    var settingsUtility: SettingsUtilityProtocol { get }
    func createRequest(movies: String, aiServer: AIServer) throws -> URLRequest
}

extension QuizUtilityProtocol {
    
    func fetchQuiz(movies: String) async throws -> [Quiz] {
        let request = try self.createRequest(movies: movies, aiServer: settingsUtility.selectedServer)
        let data = try await request.fetchData()
        let decoder = AIResponseDecoderFactory.decoder(for: settingsUtility.selectedServer)
        let quizString = try decoder.decode(from: data)
        let quizData = try quizString.toUTF8Data()
        return try Quiz.decode(from: quizData)
    }
}

struct QuizUtility: QuizUtilityProtocol {
    let settingsUtility: SettingsUtilityProtocol
    let openAIGameEndpoint: AIEndpointProtocol
    let geminiGameEndpoint: AIEndpointProtocol
    let deepSeekGameEndpoint: AIEndpointProtocol
    
    func createRequest(movies: String, aiServer: AIServer) throws -> URLRequest {
        
        let endpoint: AIEndpointProtocol =
            switch aiServer {
            case .openAI:
                openAIGameEndpoint
            case .gemini:
                geminiGameEndpoint
            case .deepSeek:
                deepSeekGameEndpoint
            }
        
        let prompt = PromptType.quiz(movies: movies, language: settingsUtility.selectedLanguage.name)
        return try endpoint.createRequest(prompt: prompt)
    }
}



