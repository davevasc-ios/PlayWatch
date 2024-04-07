//
//  GetGeminiResponseUseCase.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

import Foundation

protocol GetGeminiResponseProtocol {
    func getResponse() async throws -> String
}
struct GetGeminiResponseUseCase: GetGeminiResponseProtocol {
    var service: GeminiServiceProtocol
    
    init(service: GeminiServiceProtocol = GeminiService()) {
        self.service = service
    }
    
    func getResponse() async throws -> String {
        let text = "cuentame una historia de un azafato en Washington DC"
        let x = try await service.getResponse(text: text)
        print("GeminiResponse: \(x)")
        return "ok"
    }
    
}
