//
//  Constants.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

// MARK: - API_KEY Constants

enum KeyInfo {
    static let infoFile = (name: "APIKey-Info", type: "plist")
    static let movieDB = (key: "MOVIEDB_API_KEY", web: "https://developer.themoviedb.org/reference/intro/getting-started")
    static let openAI = (key: "OPENAI_API_KEY", web: "https://platform.openai.com/api-keys")
    static let gemini = (key: "GEMINI_API_KEY", web: "https://ai.google.dev/tutorials/setup")
}

enum KeyErrors: LocalizedError {
    case invalidFileName
    case invalidKeyName(apiKeyName: String)
    case invalidApiKey(apiKeyWeb: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidFileName:
            return "Couldn't find file '\(KeyInfo.infoFile.name).\(KeyInfo.infoFile.type)'"
        case let .invalidKeyName(apiKeyName):
            return "Couldn't find key '\(apiKeyName)' in '\(KeyInfo.infoFile.name).\(KeyInfo.infoFile.type)'"
        case let .invalidApiKey(apiKeyWeb):
            return "Follow the instructions at \(apiKeyWeb) to get an API key"
        }
    }
}

// MARK: - API Constants
enum APIConstants {
    static let baseURL = "https://randomuser.me/api"
    static let includingFields = "/?inc="
    static let fields = "id,picture,name,gender,dob,location,phone,email,login,registered"
    static let noInfo = "&noinfo"
    static let searchUsersURL = "&results="
    static let maxResults = 60
    static let queryURL = APIConstants.baseURL + APIConstants.includingFields + APIConstants.fields + APIConstants.noInfo + APIConstants.searchUsersURL + String(APIConstants.maxResults)
    static let correctStatusCode = 200
}

// MARK: - API Errors
enum APIErrors: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL found"
        case .invalidResponse:
            return "Invalid response found"
        case .invalidData:
            return "Invalid data found"
        }
    }
}

// MARK: - List Loading Status
enum ListStatus: String {
  case loading = "Loading..."
  case empty = "Empty list"
  case error = "Error loading list"
  case success = "List loaded successfully"
}

// MARK: - Accessibility Identifiers
enum Identifiers {
    static let email = "userdetail_email_identifier"
    static let password = "userdetail_password_identifier"
}
