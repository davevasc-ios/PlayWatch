//
//  GetOpenAIResponseUseCase.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

protocol GetOpenAIResponseProtocol {
    func getResponse() async throws -> String
    func getQuiz() async throws -> [MovieQuiz]
}
struct GetOpenAIResponseUseCase: GetOpenAIResponseProtocol {
    var service: OpenAIServiceProtocol
    
    init(service: OpenAIServiceProtocol = OpenAIService()) {
        self.service = service
    }
    
    func getResponse() async throws -> String {
        let text = "cuentame una historia de un azafato en Washington DC"
        let x = try await service.getResponse(text: text)
        print("OpenAIResponse: \(x)")
        return "ok"
    }
    func getQuiz() async throws -> [MovieQuiz] {
//        let text = "cuentame una historia de un azafato en Washington DC"
        return try await service.getQuiz()
//        print("OpenAIResponse: \(x)")
//        return "ok"
    }
    
}
