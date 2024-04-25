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
    
    static var searchQuery = ""
    
    static let homeSections: [FetchType] = [.cinemaPlaying,
                                            .cinemaUpcomimg,
                                            .movieTrending,
                                            .movieNew,
                                            .tvTrending,
                                            .tvNew,
                                            .personTrending,
                                            .personPopular]
    
    struct Endpoint {
        static let version = "3"
        static let dataUrl = "https://api.themoviedb.org/\(version)/"
        static let imageUrl = "https://image.tmdb.org/t/p/"
        static let nowPlaying = "\(MediaType.movie.rawValue)/now_playing?"
        static let upcoming = "\(MediaType.movie.rawValue)/upcoming?"
        static let trending = "trending/"
        static let discover = "discover/"
        static let popular = "\(MediaType.person.rawValue)/popular?"
        static var search: String {
            "search/multi?query=\(searchQuery)"
        }
        
        static let language = "language=\(Current.language.language)-\(Current.language.region)"
        
        static func request(type: FetchType) throws -> URLRequest {
            guard let url = URL(string: mediaDataUrl(type: type)) else {
                throw API.Error.invalidURL
            }
            return mediaRequest(url: url)
        }
        
        static private func mediaDataUrl(type: FetchType) -> String {
            switch type {
            case .cinemaPlaying:
                return "\(dataUrl)\(nowPlaying)\(language)&region=\(Current.language.region)"
            case .cinemaUpcomimg:
                return "\(dataUrl)\(upcoming)\(language)&region=\(Current.language.region)"
            case .movieTrending:
                return "\(dataUrl)\(trending)\(MediaType.movie.rawValue)/day?\(language)"
            case .movieNew:
                return "\(dataUrl)\(discover)\(MediaType.movie.rawValue)?language=es-ES&primary_release_date.gte=2024-04-01&primary_release_date.lte=2024-04-15&sort_by=primary_release_date.asc&watch_region=ES&with_watch_monetization_types=flatrate"
            case .tvTrending:
                return "\(dataUrl)\(trending)\(MediaType.tv.rawValue)/day?\(language)"
            case .tvNew:
                return "\(dataUrl)\(discover)\(MediaType.tv.rawValue)?first_air_date.gte=2024-04-01&first_air_date.lte=2024-04-15&language=es-ES&sort_by=first_air_date.asc&watch_region=ES&with_watch_monetization_types=flatrate"
            case .personTrending:
                return "\(dataUrl)\(trending)\(MediaType.person.rawValue)/day?\(language)"
            case .personPopular:
                return "\(dataUrl)\(popular)\(language)"
            case .trendingAll:
                return "\(dataUrl)\(trending)all/day?\(language)"
            case .searchAll:
                return "\(dataUrl)\(search)&\(language)"
            }
        }
        
        static private func mediaRequest(url: URL) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = HTTP.Method.get
            request.setValue(HTTP.Header.Value.bearer(key: API.Key.movieDB), forHTTPHeaderField: HTTP.Header.Field.authorization)
            request.setValue(HTTP.Header.Value.applicationJson, forHTTPHeaderField: HTTP.Header.Field.accept)
            return request
        }
        
        // MARK: - Image
        
        static func mediaImageUrl(file: String?, size: ImageSize) -> URL? {
            guard let url = URL(string: "\(imageUrl)\(size.rawValue)\(file ?? "")") else {
                return nil
            }
            return url
        }
    }
    
    enum FetchType: CaseIterable {
        case cinemaPlaying,
             cinemaUpcomimg,
             movieTrending,
             movieNew,
             tvTrending,
             tvNew,
             personTrending,
             personPopular,
             trendingAll,
             searchAll
        
        var title: String {
            switch self {
            case .cinemaPlaying: "Ahora en cines"
            case .cinemaUpcomimg: "Próximamente en cines"
            case .movieTrending: "Películas Destacadas"
            case .movieNew: "Películas Nuevas"
            case .tvTrending: "Series Destacadas"
            case .tvNew: "Series Nuevas"
            case .personTrending: "Personas Destacadas"
            case .personPopular: "Personas Populares"
            case .trendingAll: ""
            case .searchAll: ""
            }
        }
    }
    
    enum ImageSize: String {
        case original = "original"
        case large = "w500"
        case medium = "w400" // para filas de 3, ancho 400px
        case small = "w200"
    }
    
    // MARK: - Public Functions
    
    static func getRequest(type: FetchType) throws -> URLRequest {
       try Endpoint.request(type: type)
    }
    
    static func getImageUrl(file: String?, size: ImageSize) -> URL? {
        Endpoint.mediaImageUrl(file: file, size: size)
    }
    
    static func getDate(date: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.date(from: date)
    }
}

struct OpenAI: Codable {
    
    static let endpoint = "https://api.openai.com/v1/chat/completions"
    static let systemContent = "Eres un asistente experto en contar cuentos para niños"
    static let systemModel = "gpt-3.5-turbo"
    
    struct Body: Codable {
        var model: String = systemModel
        let messages: [Message]
    }
    
    struct Message: Codable {
        let role: Role
        let content: String
    }
    
    enum Role: String, Codable {
        case system, user
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
