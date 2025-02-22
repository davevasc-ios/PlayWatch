//
//  GeminiBody.swift
//  PlayWatch
//
//  Created by David on 25/1/25.
//

import Foundation

struct GeminiBody {
    
    struct Body: Codable {
        let generationConfig: Output
        let contents: Content
        
        enum CodingKeys: String, CodingKey {
            case generationConfig = "generation_config"
            case contents
        }
    }
    
    struct Output: Codable {
        let type: GeminiOutput
        
        enum CodingKeys: String, CodingKey {
            case type = "response_mime_type"
        }
    }
    
    struct Content: Codable {
        let parts: Part
    }
    
    struct Part: Codable {
        let text: String
    }
}

// MARK: - Encoding
extension GeminiBody {
    
    static func encode(output: GeminiOutput,
                       prompt: PromptType,
                       using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        let format = Output(type: output)
        let content = Content(parts: Part(text: prompt.description))
        do {
            return try encoder.encode(Body(generationConfig: format, contents: content))
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}
