//
//  Constants.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

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

struct MovieDB {
    
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
        request.setValue(HTTP.Header.Value.bearer(key: API.Key.movieDB), forHTTPHeaderField: HTTP.Header.Field.authorization)
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

struct OpenAI: Codable {
    
    static let endpoint = "https://api.openai.com/v1/chat/completions"
    static let systemContent = "Eres un asistente experto en contar cuentos para niños"
    static let systemModel = "gpt-3.5-turbo"
    
    enum Role: String, Codable {
        case system, user
    }
    
    struct Message: Codable {
        let role: Role
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
        request.setValue(HTTP.Header.Value.bearer(key: API.Key.openAI), forHTTPHeaderField: HTTP.Header.Field.authorization)
        request.setValue(HTTP.Header.Value.applicationJson, forHTTPHeaderField: HTTP.Header.Field.contentType)
        
        let systemMessage = Message(role: .system, content: systemContent)
        let userMessage = Message(role: .user, content: text)
        let body = Body(messages: [systemMessage, userMessage])
        
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
    
}


struct Gemini: Codable {
    
    static let systemModel = "gemini-pro"
    static let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(systemModel):generateContent?key=\(API.Key.gemini)"
    
    struct Body: Codable {
        let contents: Content
    }
    
    struct Content: Codable {
        let parts: Part
    }
    
    struct Part: Codable {
        let text: String
    }
    
    static func request(text: String) async throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw API.Error.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTP.Method.post
        request.setValue(HTTP.Header.Value.applicationJson, forHTTPHeaderField: HTTP.Header.Field.contentType)

        let body = Body(contents: Content(parts: Part(text: text)))
        
        request.httpBody = try? JSONEncoder().encode(body)
        return request
    }
    
}



// MARK: - Accessibility Identifiers
enum Identifiers {
    static let email = "userdetail_email_identifier"
    static let password = "userdetail_password_identifier"
}
