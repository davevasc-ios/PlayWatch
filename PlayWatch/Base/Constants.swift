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
    static let dateFormat = "yyyy-MM-dd"
    static let maxPages = 500
    static let voteAverageGte = 5
    static let voteCountGte = 100
    
    // TODO: - Considerar guardar el valor en otro sitio
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
        static let version = 3
        static let dataUrl = "https://api.themoviedb.org/\(String(version))/"
        static let imageUrl = "https://image.tmdb.org/t/p/"
        static let nowPlaying = "\(MediaType.movie)/now_playing"
        static let upcoming = "\(MediaType.movie)/upcoming"
        static let trending = "trending/"
        static let discover = "discover/"
        static let popular = "\(MediaType.person)/popular"
        static var search: String {
            "search/multi?query=\(searchQuery)"
        }
                
        static func request(type: FetchType) throws -> URLRequest {
            return HTTP.request(url: try mediaURL(type: type), method: .get, fields: self.headerFields)
        }
        
        static private func mediaURL(type: FetchType) throws -> URL {
            var urlString: String = ""
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: QueryParams.language.rawValue, value: "es-ES"))
            switch type {
            case .cinemaPlaying:
                urlString = "\(dataUrl)\(nowPlaying)"
                queryItems.append(URLQueryItem(name: QueryParams.region.rawValue, value:"ES"))
            case .cinemaUpcomimg:
                urlString = "\(dataUrl)\(upcoming)"
                queryItems.append(URLQueryItem(name: QueryParams.region.rawValue, value:"ES"))
            case .movieTrending:
                urlString = "\(dataUrl)\(trending)\(MediaType.movie)/day"
            case .movieNew:
                urlString = "\(dataUrl)\(discover)\(MediaType.movie)?language=es-ES&primary_release_date.gte=2024-04-01&primary_release_date.lte=2024-04-15&sort_by=primary_release_date.asc&watch_region=ES&with_watch_monetization_types=flatrate"
            case .tvTrending:
                urlString = "\(dataUrl)\(trending)\(MediaType.tv)/day"
            case .tvNew:
                urlString = "\(dataUrl)\(discover)\(MediaType.tv)?first_air_date.gte=2024-04-01&first_air_date.lte=2024-04-15&language=es-ES&sort_by=first_air_date.asc&watch_region=ES&with_watch_monetization_types=flatrate"
            case .personTrending:
                urlString = "\(dataUrl)\(trending)\(MediaType.person)/day"
            case .personPopular:
                urlString = "\(dataUrl)\(popular)"
            case .trendingAll:
                urlString = "\(dataUrl)\(trending)\(MediaType.all)/day"
            case .searchAll:
                urlString = "\(dataUrl)\(search)"
            case .randomMovies:
                urlString = "\(dataUrl)\(discover)\(MediaType.movie)"
                queryItems.append(URLQueryItem(name: QueryParams.page.rawValue, value: getRandomPage()))
                queryItems.append(URLQueryItem(name: "\(QueryParams.releaseDate.rawValue)\(QueryDirection.lte.rawValue)", value: getCurrentDateString()))
                queryItems.append(URLQueryItem(name: QueryParams.sortBy.rawValue, value: "\(SortBy.revenue)\(SortDirection.asc.rawValue)"))
                queryItems.append(URLQueryItem(name: "\(QueryParams.voteAverage.rawValue)\(QueryDirection.gte.rawValue)", value: String(voteAverageGte)))
                queryItems.append(URLQueryItem(name: "\(QueryParams.voteCount.rawValue)\(QueryDirection.gte.rawValue)", value: String(voteCountGte)))
            }
            
            guard let url = URL(string: urlString),
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw API.Error.invalidURL
            }
            
            components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

            guard let finalURL = components.url else {
                    throw API.Error.invalidURL
                }
            return finalURL
        }
        
        static let headerFields: [String : String] = [
            HTTP.Header.Field.accept.rawValue: HTTP.Header.Value.applicationJson.description,
            HTTP.Header.Field.authorization.rawValue: HTTP.Header.Value.bearer(.movieDB).description
        ]
        
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
             searchAll,
             randomMovies
        
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
            case .randomMovies: ""
            }
        }
    }
    
    enum ImageSize: String {
        case original = "original",
             large = "w500",
             medium = "w400", // para filas de 3, ancho 400px
             small = "w200"
    }
    
    enum SortBy: String, CaseIterable {
        case orignalTitle = "original_title",
             popularity,
             revenue,
             releaseDate = "primary_release_date",
             title, // originalTitle
             voteAverage = "vote_average",
             voteCount = "vote_count"
    }
    
    static let validShortBy: Set<SortBy> = [
      .popularity,
      .revenue,
      .voteAverage,
      .voteCount
    ]
    
    enum SortDirection: String, CaseIterable {
        case asc = ".asc",
             desc = ".desc"
    }
    
    enum QueryParams: String {
        case language,
             region,
             page,
             releaseDate = "primary_release_date",
             sortBy = "sort_by",
             voteAverage = "vote_average",
             voteCount = "vote_count"
    }
    
    static let discoverQueryParams: Set<QueryParams> = [
        .language,
        .page,
        .releaseDate,
        .sortBy,
        .voteAverage,
        .voteCount
    ]
    
    enum QueryDirection: String {
        case gte = ".gte",
             lte = ".lte"
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
    
    static func getRandomPage() -> String {
        return String(Int.random(in: 1...maxPages))
    }
    
    static func getRandomShortBy() -> String {
        let randomShortBy = validShortBy.randomElement() ?? .popularity
        let randomShortDirection = SortDirection.allCases.randomElement() ?? .asc
        return "\(randomShortBy)\(randomShortDirection)"
    }
    
    static func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: Date())
    }
}

struct OpenAI: Codable {
    
    static let endpoint = "https://api.openai.com/v1/chat/completions"
    static let systemContent = "Eres un asistente experto en contar cuentos para niños"
    static let systemModel = "gpt-3.5-turbo"
    
    static let headerFields: [String : String] = [
        HTTP.Header.Field.contentType.rawValue: HTTP.Header.Value.applicationJson.description,
        HTTP.Header.Field.authorization.rawValue: HTTP.Header.Value.bearer(.openAI).description
    ]
    
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
                
        let systemMessage = Message(role: .system, content: systemContent)
        let userMessage = Message(role: .user, content: text)
        let body = try? JSONEncoder().encode(Body(messages: [systemMessage, userMessage]))
        
        return HTTP.request(url: url, method: .post, fields: headerFields, body: body)
    }
    
}


struct Gemini: Codable {
    
    static let systemModel = "gemini-pro"
    static let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(systemModel):generateContent?key=\(API.Key.gemini)"
    
    static let headerFields: [String : String] = [
        HTTP.Header.Field.contentType.rawValue: HTTP.Header.Value.applicationJson.description
    ]
    
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

        let body = try? JSONEncoder().encode(Body(contents: Content(parts: Part(text: text))))
        
        return HTTP.request(url: url, method: .post, fields: headerFields, body: body)
    }
    
}



// MARK: - Accessibility Identifiers
enum Identifiers {
    static let email = "userdetail_email_identifier"
    static let password = "userdetail_password_identifier"
}
