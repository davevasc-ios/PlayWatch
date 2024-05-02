//
//  API.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

struct API {
    
    struct Info {
        static let infoFile = (name: "APIKey-Info", type: "plist")
        static let movieDB = (key: "MOVIEDB_API_KEY", web: "https://developer.themoviedb.org/reference/intro/getting-started")
        static let openAI = (key: "OPENAI_API_KEY", web: "https://platform.openai.com/api-keys")
        static let gemini = (key: "GEMINI_API_KEY", web: "https://ai.google.dev/tutorials/setup")
    }
    
    enum Key: String, CustomStringConvertible {
        case movieDB, openAI, gemini
        
        var api: (key: String, web: String) {
            switch self {
            case .movieDB:
                return Info.movieDB
            case .openAI:
                return Info.openAI
            case .gemini:
                return Info.gemini
            }
        }
        
        var description: String {
            guard let filePath = Bundle.main.path(forResource: Info.infoFile.name, ofType: Info.infoFile.type) else {
                fatalError(Error.invalidFileName.localizedDescription)
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: self.api.key) as? String else {
                fatalError(Error.invalidKeyName(apiKeyName: self.api.key).localizedDescription)
            }
            if value.isEmpty {
                fatalError(Error.invalidApiKey(apiKeyWeb: self.api.web).localizedDescription)
            }
            return value
        }
    }
    
    enum Error: LocalizedError {
        case invalidFileName
        case invalidKeyName(apiKeyName: String)
        case invalidApiKey(apiKeyWeb: String)
        case invalidURL
        case invalidResponse(detail: String)
        case invalidData(detail: String)
        
        var errorDescription: String? {
            switch self {
            case .invalidFileName:
                return "Couldn't find file '\(Info.infoFile.name).\(Info.infoFile.type)'"
            case let .invalidKeyName(apiKeyName):
                return "Couldn't find key '\(apiKeyName)' in '\(Info.infoFile.name).\(Info.infoFile.type)'"
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
    
    enum Status: String {
        case loading = "Loading data...",
             success = "Data loaded successfully",
             empty = "Empty data",
             error = "Error loading data"
    }
}
