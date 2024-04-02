//
//  APIKey.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

enum APIKey: String, CustomStringConvertible {
    case movieDB, openAI, gemini
    
    var api: (key: String, web: String) {
        switch self {
        case .movieDB:
            return Key.Info.movieDB
        case .openAI:
            return Key.Info.openAI
        case .gemini:
            return Key.Info.gemini
        }
    }
    
    var description: String {
        guard let filePath = Bundle.main.path(forResource: Key.Info.infoFile.name, ofType: Key.Info.infoFile.type) else {
            fatalError(Key.Error.invalidFileName.localizedDescription)
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: self.api.key) as? String else {
            fatalError(Key.Error.invalidKeyName(apiKeyName: self.api.key).localizedDescription)
        }
        if value.isEmpty {
            fatalError(Key.Error.invalidApiKey(apiKeyWeb: self.api.web).localizedDescription)
        }
        return value
    }
}

        
        
  
