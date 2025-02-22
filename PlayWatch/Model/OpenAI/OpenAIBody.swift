//
//  OpenAIBody.swift
//  PlayWatch
//
//  Created by David on 25/1/25.
//

import Foundation

struct OpenAIBody<Model: OpenAIModelCompatible> where Model.ModelType.RawValue == String {
    
    struct Body: Codable {
        let model: Model.ModelType
        let responseFormat: Output
        let messages: [Message]
        
        enum CodingKeys: String, CodingKey {
            case model
            case responseFormat = "response_format"
            case messages
        }
    }
    
    struct Output: Codable {
        let type: OpenAIOutput
    }

    struct Message: Codable {
        let role: Role
        let content: String
    }
    
    enum Role: String, Codable {
        case system, user
    }
}

// MARK: - Encoding
extension OpenAIBody {
    
    static func encode(modelCompatible: Model,
                       systemMode: OpenAISystemMode,
                       output: OpenAIOutput,
                       prompt: PromptType,
                       using encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        let systemMessage = Message(role: .system, content: systemMode.rawValue)
        let userMessage = Message(role: .user, content: prompt.description)
        let format = Output(type: output)
        do {
            return try encoder.encode(Body(model: modelCompatible.model, responseFormat: format, messages: [systemMessage, userMessage]))
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}
