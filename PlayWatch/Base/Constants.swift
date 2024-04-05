//
//  Constants.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

// MARK: - API_KEY Constants

struct Key {
    struct Info {
        static let infoFile = (name: "APIKey-Info", type: "plist")
        static let movieDB = (key: "MOVIEDB_API_KEY", web: "https://developer.themoviedb.org/reference/intro/getting-started")
        static let openAI = (key: "OPENAI_API_KEY", web: "https://platform.openai.com/api-keys")
        static let gemini = (key: "GEMINI_API_KEY", web: "https://ai.google.dev/tutorials/setup")
    }
    
    enum Error: LocalizedError {
        case invalidFileName
        case invalidKeyName(apiKeyName: String)
        case invalidApiKey(apiKeyWeb: String)
        
        var errorDescription: String? {
            switch self {
            case .invalidFileName:
                return "Couldn't find file '\(Info.infoFile.name).\(Info.infoFile.type)'"
            case let .invalidKeyName(apiKeyName):
                return "Couldn't find key '\(apiKeyName)' in '\(Info.infoFile.name).\(Info.infoFile.type)'"
            case let .invalidApiKey(apiKeyWeb):
                return "Follow the instructions at \(apiKeyWeb) to get an API key"
            }
        }
    }
}

// MARK: - MovieDB API Constants

enum AppLanguage {
    static let spanish = (englishName: "Spanish", nativeName: "Español", language: "es", region: "ES")
    static let basque = (englishName: "Basque", nativeName: "Euskera", language: "eu", region: "ES")
    static let catalan = (englishName: "Catalan", nativeName: "Català", language: "ca", region: "ES")
    static let englishGB = (englishName: "English (GB)", nativeName: "English (GB)", language: "en", region: "GB")
    static let englishUS = (englishName: "English (US)", nativeName: "English (US)", language: "en", region: "US")
    static let french = (englishName: "French", nativeName: "Français", language: "fr", region: "FR")
    static let italian = (englishName: "Italian", nativeName: "Italiano", language: "it", region: "IT")
    static let portuguese = (englishName: "Portuguese", nativeName: "Português", language: "pt", region: "PT")
    static let german = (englishName: "German", nativeName: "Deutsch", language: "de", region: "DE")
}





struct Current {
    static var language = AppLanguage.spanish
    static var theme = ""
}


struct HTTP {
    struct Method {
        static let get = "GET"
        static let post = "POST"
    }
    struct StatusCode {
        static let success = 200
    }
    struct Header {
        struct Field {
            static let authorization = "Authorization"
            static let accept = "accept"
            static let contentType = "Content-Type"
        }
        struct Value {
            static let applicationJson = "application/json"
            static func bearer(key: APIKey) -> String {
                return "Bearer \(key)"
            }
        }
    }
}




struct MdbAPI {
    
    enum ImageSize: String {
        case large = "w500"
        case medium = "w400" // para filas de 3, ancho 400px
        case small = "w200"
    }
    
    static let endpoint = "https://api.themoviedb.org/3/"
    static let imageEndpoint = "https://image.tmdb.org/t/p/"
    static let language = "language=\(Current.language.language)-\(Current.language.region)"

    struct QueryData {
        var mode: Fetch = .cinema
        var media: Media = .movie
        var period: Period = .week
        var provider: Provider = .netflix
        var query: String = ""
    }
    
    enum Media {
        case movie, tv, person
    }

    enum Period {
        case day, week
    }
    
    enum Provider: Int {
        case netflix = 8
        case hbo = 9
    }

    static func request(query: QueryData) throws -> URLRequest {
        guard let url = URL(string: url(query: query)) else {
            throw API.Error.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTP.Method.get
        request.setValue(HTTP.Header.Value.bearer(key: APIKey.movieDB), forHTTPHeaderField: HTTP.Header.Field.authorization)
        request.setValue(HTTP.Header.Value.applicationJson, forHTTPHeaderField: HTTP.Header.Field.accept)
        return request
    }
    
    enum Fetch {
        case trend, cinema, coming, stream, search
    }
    
    static func url(query: QueryData) -> String {
        switch query.mode {
        case .trend:
            return "\(endpoint)trending/\(query.media)/\(query.period)?\(language)"
        case .cinema:
            return "\(endpoint)movie/now_playing?\(language)&region=\(Current.language.region)"
        case .coming:
            return "\(endpoint)movie/upcoming?\(language)&region=\(Current.language.region)"
        case .stream:
            return "\(endpoint)discover/\(query.media)?\(language)&sort_by=popularity.desc&watch_region=\(Current.language.region)&with_watch_providers=\(query.provider.rawValue)"
        case .search:
            return "\(endpoint)search/multi?query=\(query.query)&\(language)"
        }
    }
    
    static func imageUrl(file: String, size: ImageSize) -> String {
        "\(imageEndpoint)\(size)\(file)"
    }

    
}

struct OaiAPI: Codable {
    
    static let endpoint = "https://api.openai.com/v1/chat/completions"
    static let systemContent = "Eres un asistente experto en contar cuentos para niños"
    static let systemModel = "gpt-3.5-turbo"
    
    enum OaiRole: String, Codable {
        case system, user
    }
    
    struct Message: Codable {
        let role: OaiRole
        let content: String
    }

    struct Body: Codable {
        var model: String = systemModel
        let messages: [Message]
    }
    
    static func request(text: String) async throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw API.Error.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTP.Method.post
        request.setValue(HTTP.Header.Value.bearer(key: APIKey.openAI), forHTTPHeaderField: HTTP.Header.Field.authorization)
        request.setValue(HTTP.Header.Value.applicationJson, forHTTPHeaderField: HTTP.Header.Field.contentType)
        
        let systemMessage = Message(role: .system, content: systemContent)
        let userMessage = Message(role: .user, content: text)
        let body = Body(messages: [systemMessage, userMessage])
        
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
    
}


struct API {
    // MARK: - API Errors
    enum Error: LocalizedError {
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
    
    // MARK: - API Status
    enum Status: String {
        case loading = "Loading..."
        case empty = "Empty list"
        case error = "Error loading list"
        case success = "List loaded successfully"
    }
}

// MARK: - Accessibility Identifiers
enum Identifiers {
    static let email = "userdetail_email_identifier"
    static let password = "userdetail_password_identifier"
}
