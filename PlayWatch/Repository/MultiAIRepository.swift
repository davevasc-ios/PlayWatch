//
//  MultiAIRepository.swift
//  PlayWatch
//
//  Created by David on 10/11/24.
//

import Foundation

protocol MultiAIRepositoryProtocol {
    func createRequest(config: GameRequestConfig) throws -> URLRequest
}

extension MultiAIRepositoryProtocol {
    func fetchQuiz(config: GameRequestConfig) async throws -> [Quiz] {
        let request = try self.createRequest(config: config)
        let data = try await request.fetchData()
        let decoder = AIResponseDecoderFactory.decoder(for: config.aiServer)
        let quizString = try decoder.decode(from: data)
        let quizData = try quizString.toUTF8Data()
        return try Quiz.decode(from: quizData)
    }
}

struct MultiAIRepository: MultiAIRepositoryProtocol {
    private let endpointFactory: AIEndpointFactoryProtocol

    init(endpointFactory: AIEndpointFactoryProtocol = AIEndpointFactory()) {
        self.endpointFactory = endpointFactory
    }
    
    func createRequest(config: GameRequestConfig) throws -> URLRequest {
        let endpoint = self.endpointFactory.resolveEndpoint(for: config.aiServer)
        return try endpoint.createRequest(movies: config.movies, language: config.language)
    }
}
