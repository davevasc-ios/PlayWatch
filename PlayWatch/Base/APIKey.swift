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
            return KeyInfo.movieDB
        case .openAI:
            return KeyInfo.openAI
        case .gemini:
            return KeyInfo.gemini
        }
    }
    
    var description: String {
        guard let filePath = Bundle.main.path(forResource: KeyInfo.infoFile.name, ofType: KeyInfo.infoFile.type) else {
            fatalError(KeyErrors.invalidFileName.localizedDescription)
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: self.api.key) as? String else {
            fatalError(KeyErrors.invalidKeyName(apiKeyName: self.api.key).localizedDescription)
        }
        if value.isEmpty {
            fatalError(KeyErrors.invalidApiKey(apiKeyWeb: self.api.web).localizedDescription)
        }
        return value
    }
}

        
        
  
