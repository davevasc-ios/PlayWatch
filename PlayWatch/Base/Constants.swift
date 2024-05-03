//
//  Constants.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation
import SwiftUI

struct RemoteImage {
    static let dummyUrl = "https://image.tmdb.org/t/p/w500/6tJWxRfBKWGIPFkfLTod2CgCexU.jpg"
    
    enum Error: String {
        case cancelled
    }
}

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

// MARK: - MovieDB API Constants
struct MovieDB {
    static let dateFormat = "yyyy-MM-dd"
    
    static let homeSections: [FetchType] = [.randomMovies,
                                            .cinemaPlaying,
                                            .cinemaUpcomimg,
                                            .movieTrending,
                                            .movieNew,
                                            .tvTrending,
                                            .tvNew,
                                            .personTrending,
                                            .personPopular]
    
    struct Endpoint {
        
        // MARK: - Data
        static private let version = 3
        static private let dataUrl = "https://api.themoviedb.org/\(String(version))/"
        static private let nowPlaying = "\(MediaType.movie)/now_playing"
        static private let upcoming = "\(MediaType.movie)/upcoming"
        static private let trending = "trending/"
        static private let discover = "discover/"
        static private let popular = "\(MediaType.person)/popular"
        static private var search = "search/multi"
        
        static private let maxPages = 500
        static private let voteAverageGte = 5
        static private let voteCountQuizGte = 100
        static private let voteCountNewGte = 4
        static private let daysOffset = 14
        
        static private func randomShortBy() -> String {
            let randomShortBy = validShortBy.randomElement() ?? .popularity
            let randomShortDirection = SortDirection.allCases.randomElement() ?? .asc
            return "\(randomShortBy)\(randomShortDirection)"
        }
        
        static private func currentDateString(daysOffset: Int = 0) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            guard let modifiedDate = Calendar.current.date(byAdding: .day, value: daysOffset, to: Date()) else {
                return ""
            }
            return dateFormatter.string(from: modifiedDate)
        }
        
        static fileprivate let headerFields: [String : String] = [
            HTTP.Header.Field.accept.rawValue: HTTP.Header.Value.applicationJson.description,
            HTTP.Header.Field.authorization.rawValue: HTTP.Header.Value.bearer(.movieDB).description
        ]
        
        static fileprivate func mediaDataUrl(type: FetchType, searchText: String?) throws -> URL {
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
                urlString = "\(dataUrl)\(trending)\(MediaType.movie)/\(MediaPeriod.day)"
            case .movieNew:
                urlString = "\(dataUrl)\(discover)\(MediaType.movie)"
                queryItems.append(URLQueryItem(name: "\(QueryParams.releaseDate.rawValue)\(QueryDirection.gte.rawValue)", value: currentDateString(daysOffset: -daysOffset)))
                queryItems.append(URLQueryItem(name: "\(QueryParams.releaseDate.rawValue)\(QueryDirection.lte.rawValue)", value: currentDateString(daysOffset: daysOffset*2)))
                queryItems.append(URLQueryItem(name: QueryParams.sortBy.rawValue, value: "\(SortBy.releaseDate.rawValue)\(SortDirection.asc.rawValue)"))
                queryItems.append(URLQueryItem(name: QueryParams.watchRegion.rawValue, value: "ES"))
                queryItems.append(URLQueryItem(name: QueryParams.withWatchMonetizationTypes.rawValue, value: MonetizationType.flatrate.rawValue))
                queryItems.append(URLQueryItem(name: "\(QueryParams.voteCount.rawValue)\(QueryDirection.gte.rawValue)", value: String(voteCountNewGte)))
            case .tvTrending:
                urlString = "\(dataUrl)\(trending)\(MediaType.tv)/\(MediaPeriod.day)"
            case .tvNew:
                urlString = "\(dataUrl)\(discover)\(MediaType.tv)"
                queryItems.append(URLQueryItem(name: "\(QueryParams.firstAirDate.rawValue)\(QueryDirection.gte.rawValue)", value: currentDateString(daysOffset: -daysOffset)))
                queryItems.append(URLQueryItem(name: "\(QueryParams.firstAirDate.rawValue)\(QueryDirection.lte.rawValue)", value: currentDateString(daysOffset: daysOffset*2)))
                queryItems.append(URLQueryItem(name: QueryParams.sortBy.rawValue, value: "\(SortBy.firstAirDate.rawValue)\(SortDirection.asc.rawValue)"))
                queryItems.append(URLQueryItem(name: QueryParams.watchRegion.rawValue, value: "ES"))
                queryItems.append(URLQueryItem(name: QueryParams.withWatchMonetizationTypes.rawValue, value: MonetizationType.flatrate.rawValue))
                queryItems.append(URLQueryItem(name: "\(QueryParams.voteCount.rawValue)\(QueryDirection.gte.rawValue)", value: String(voteCountNewGte)))
            case .personTrending:
                urlString = "\(dataUrl)\(trending)\(MediaType.person)/\(MediaPeriod.day)"
            case .personPopular:
                urlString = "\(dataUrl)\(popular)"
            case .trendingAll:
                urlString = "\(dataUrl)\(trending)\(MediaType.all)/\(MediaPeriod.day)"
            case .searchAll:
                if let text = searchText {
                    urlString = "\(dataUrl)\(search)"
                    queryItems.append(URLQueryItem(name: QueryParams.query.rawValue, value: text))
                }
            case .randomMovies:
                urlString = "\(dataUrl)\(discover)\(MediaType.movie)"
                queryItems.append(URLQueryItem(name: QueryParams.page.rawValue, value: String(Int.random(in: 1...maxPages))))
                queryItems.append(URLQueryItem(name: "\(QueryParams.releaseDate.rawValue)\(QueryDirection.lte.rawValue)", value: currentDateString()))
                queryItems.append(URLQueryItem(name: QueryParams.sortBy.rawValue, value: randomShortBy()))
                queryItems.append(URLQueryItem(name: "\(QueryParams.voteAverage.rawValue)\(QueryDirection.gte.rawValue)", value: String(voteAverageGte)))
                queryItems.append(URLQueryItem(name: "\(QueryParams.voteCount.rawValue)\(QueryDirection.gte.rawValue)", value: String(voteCountQuizGte)))
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
        
        // MARK: - Image
        static private let imageUrl = "https://image.tmdb.org/t/p/"
        
        static fileprivate func mediaImageUrl(file: String?, size: ImageSize) -> URL? {
            guard let url = URL(string: "\(imageUrl)\(size.rawValue)\(file ?? "")") else {
                return nil
            }
            return url
        }
    }
    
    enum FetchType {
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
            case .randomMovies: "Random Movies"
            }
        }
    }
    
    enum ImageSize: String {
        case original = "original",
             large = "w500",
             medium = "w400", // para filas de 3, ancho 400px
             small = "w200"
    }
    
    enum SortBy: String {
        case orignalTitle = "original_title",
             popularity,
             revenue,
             releaseDate = "primary_release_date",
             title, // originalTitle
             voteAverage = "vote_average",
             voteCount = "vote_count",
             firstAirDate = "first_air_date"
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
             voteCount = "vote_count",
             watchRegion = "watch_region",
             withWatchMonetizationTypes = "with_watch_monetization_types",
             firstAirDate = "first_air_date",
             query
    }

    
    enum QueryDirection: String {
        case gte = ".gte",
             lte = ".lte"
    }
    
    enum MonetizationType: String {
        case flatrate,
             free,
             ads,
             rent,
             buy
    }
    
    // MARK: - Public Functions
    
    static func getRequest(type: FetchType, searchText: String?) throws -> URLRequest {
        return HTTP.request(url: try Endpoint.mediaDataUrl(type: type, searchText: searchText), method: .get, fields: Endpoint.headerFields)
    }
    
    static func getImageUrl(file: String?, size: ImageSize) -> URL? {
        Endpoint.mediaImageUrl(file: file, size: size)
    }
    
    static func getDate(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.date(from: date)
    }
}

struct OpenAI: Codable {
    
    static let quizLanguage = "Spanish"
    static let endpoint = "https://api.openai.com/v1/chat/completions"
    static let systemModel = "gpt-3.5-turbo"
    
    static let headerFields: [String : String] = [
        HTTP.Header.Field.contentType.rawValue: HTTP.Header.Value.applicationJson.description,
        HTTP.Header.Field.authorization.rawValue: HTTP.Header.Value.bearer(.openAI).description
    ]
    
    enum SystemContent: String {
        case json = "You are an assistant that only generates a valid JSON files. You will always return only a valid JSON file, don’t write nothing outside from JSON file.",
             translator = "You are an assistant that only translate one text in other. You will always return only a valid translated text, don’t write nothing outside from a valid translation text."
    }
    
    enum UserPrompt: CustomStringConvertible {
        case quiz(String),
             text(String)
        
        var description: String {
            switch self {
            case .quiz(let movies):
                return
    """
    Give me a just a valid JSON Array of following structure, each one, about one of these movies (no 'movies' field, no 'data' field, just array): \(movies).
    
    Field 1: 'question' (String), a very difficult and original question whose answer is true or false (Ensure that the number of true answers is roughly equal to the number of false answers), about the corresponding movie, in '\(quizLanguage)' language
    Field 2: 'result' (Boolean), the answer of the previous question, which can only be true or false
    """
            case .text(let text):
                return text
            }
        }
    }
    
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
    
    static func request(type: UserPrompt) async throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw API.Error.invalidURL
        }
        var systemContent = ""
        switch type {
        case .quiz:
            systemContent = SystemContent.json.rawValue
        case .text:
            systemContent = SystemContent.translator.rawValue
        }
        let systemMessage = Message(role: .system, content: systemContent)
        let userMessage = Message(role: .user, content: type.description)
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
