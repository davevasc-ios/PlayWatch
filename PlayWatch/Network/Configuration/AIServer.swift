//
//  AIServer.swift
//  PlayWatch
//
//  Created by David on 1/2/25.
//

import Foundation

enum AIServer: String, CaseIterable, Identifiable, Codable {
    
    case openAI = "OpenAI"
    case gemini = "Gemini"
    case deepSeek = "DeepSeek"
    
    var id: Self { self }
}
