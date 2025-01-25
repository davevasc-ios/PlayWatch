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
        let quizString = try config.aiServer.decodeQuizResponse(from: data)
        let quizData = try quizString.toUTF8Data()
        return try Quiz.decode(from: quizData)
    }
}

struct MultiAIRepository: MultiAIRepositoryProtocol {
    let endpoint: EndpointProtocol
    
    init(endpoint: EndpointProtocol = MultiAIEndpoint()) {
        self.endpoint = endpoint
    }
    
    func createRequest(config: GameRequestConfig) throws -> URLRequest {
        try self.endpoint.createRequest(config: config)
    }
}
