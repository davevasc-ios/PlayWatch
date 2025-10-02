//
//  QuizUtility.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol QuizFetching: Sendable {
    func fetchQuiz(for movies: String) async throws -> [Quiz]
}

protocol QuizUtilityProtocol: QuizFetching {
    var settingsUtility: SettingsReadable { get } // SettingsUtilityProtocol SettingsUtilityProtocol { get }
    func createRequest(for movies: String) async throws -> URLRequest
}

extension QuizUtilityProtocol {
    
    func fetchQuiz(for movies: String) async throws -> [Quiz] {
        let request = try await createRequest(for: movies)
        let data = try await request.fetchData()
        let decoder = AIResponseDecoderFactory.decoder(for: settingsUtility.selectedServer)
        let quizString = try decoder.decode(from: data)
        let quizData = try quizString.toUTF8Data()
        return try Quiz.decode(from: quizData)
    }
}

// TODO: - rehacer los previews en mock en vez de json, y así mejorar los quiz y los media utility

struct QuizUtility: QuizUtilityProtocol {
    let settingsUtility: SettingsReadable
    let aiRequestProvider: AIRequestProviding
    
    func createRequest(for movies: String) async throws -> URLRequest {
        let prompt = PromptType.quiz(movies: movies, language: settingsUtility.selectedLanguage.englishName)
        return try await aiRequestProvider.createRequest(for: settingsUtility.selectedServer, with: prompt)
    }
}
