//
//  GetGeminiResponseUseCase.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

import Foundation

protocol GetGeminiResponseProtocol {
    func getResponse(prompt: String) async throws -> String
}
struct GetGeminiResponseUseCase: GetGeminiResponseProtocol {
    var service: GeminiServiceProtocol
    
    init(service: GeminiServiceProtocol = GeminiService()) {
        self.service = service
    }
    
    func getResponse(prompt: String) async throws -> String {
        return try await service.getResponse(prompt: prompt)
   
    }
    
}
