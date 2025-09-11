//
//  QuizUtility.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol QuizUtilityProtocol {
    var settingsUtility: SettingsReadable { get } // SettingsUtilityProtocol SettingsUtilityProtocol { get }
    func createRequest(movies: String) async throws -> URLRequest
}

extension QuizUtilityProtocol {
    
    func fetchQuiz(movies: String) async throws -> [Quiz] {
        let request = try await self.createRequest(movies: movies)
        let data = try await request.fetchData()
        let decoder = AIResponseDecoderFactory.decoder(for: settingsUtility.selectedServer)
        let quizString = try decoder.decode(from: data)
        let quizData = try quizString.toUTF8Data()
        return try Quiz.decode(from: quizData)
    }
}

struct QuizUtility: QuizUtilityProtocol {
    let settingsUtility: SettingsReadable
    let endpointProvider: AIEndpointProviding
    
    func createRequest(movies: String) async throws -> URLRequest {
        let endpoint = await endpointProvider.endpoint(for: settingsUtility.selectedServer)
        let prompt = PromptType.quiz(movies: movies, language: settingsUtility.selectedLanguage.englishName)
        return try endpoint.createRequest(prompt: prompt)
    }
}



