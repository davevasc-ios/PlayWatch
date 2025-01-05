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
            if value.isTrimmedEmpty {
                fatalError(Error.invalidApiKey(apiKeyWeb: self.api.web).localizedDescription)
            }
            return value
        }
    }
    
    enum Status: String {
        case loading = "Loading data...",
             success = "Data loaded successfully",
             empty = "Empty data",
             error = "Error loading data"
    }
}
