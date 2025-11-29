//
//  API+Errors.swift
//  PlayWatch
//
//  Created by David on 5/1/25.
//

import Foundation

extension API {
    enum Error: LocalizedError {
        case invalidFileName(fileName: String, fileType: String)
        case invalidKeyName(apiKeyName: String, fileName: String, fileType: String)
        case invalidApiKey(apiKeyWeb: String)
        case invalidURL
        case invalidResponse(detail: String)
        case invalidData(detail: String)
        
        var errorDescription: String? {
            switch self {
            case let .invalidFileName(fileName, fileType):
                return "Couldn't find file '\(fileName).\(fileType)'"
            case let .invalidKeyName(apiKeyName, fileName, fileType):
                return "Couldn't find key '\(apiKeyName)' in '\(fileName).\(fileType)'"
            case let .invalidApiKey(apiKeyWeb):
                return "Follow the instructions at \(apiKeyWeb) to get an API key"
            case .invalidURL:
                return "Invalid URL found"
            case let .invalidResponse(detail):
                return "Invalid response found:\n\(detail)"
            case let .invalidData(detail):
                return "Invalid data found:\n\(detail)"
            }
        }
    }
}
