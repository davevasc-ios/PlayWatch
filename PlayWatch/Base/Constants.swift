//
//  Constants.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation
import SwiftUI

struct Constants {
    
    struct Game {
        static let screenCutoffScale: CGFloat = 0.8 / 2
        static let questionHeightScale: CGFloat = 0.15
        static let quizWidhtScale: CGFloat = 0.65
        static let quizCardDegrees: CGFloat = 12
        static let typingTextIntervales: [UInt64] = [10000000, 20000000, 30000000, 40000000, 50000000]
        static let swipeDownDegrees: [Double] = [-30, -20, -10, 0, 10, 20, 30]
        static let numberOfQuizzes = 20
        static let secondsPerQuiz = 6
        
        enum Error: LocalizedError {
            case outOfRange
            
            var errorDescription: String? {
                switch self {
                case .outOfRange:
                    return "Data is out of range"
                }
            }
        }
    }
    
    enum ResourceFiles {
        static let all = "All"
        static let movies = "Movies"
        static let people = "People"
        static let quizzes = "Quizzes"
        static let tvShows = "TVShows"
    }
}

// MARK: - MovieDB API Constants
struct MovieDB {
    
    struct Locale {
        var name: String = .empty
        var code: String = .empty
        var region: String = .empty
        var language: String {
            "\(code)-\(region)"
        }
    }
    
    static let dateFormat = "yyyy-MM-dd"
    
    static let homeSections: [FetchType] = [
        .randomMovies,
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
        static private let search = "search/multi"
        
        static private let maxPages = 500
        static private let voteAverageGte = 5
        static private let voteCountQuizGte = 100
        static private let voteCountNewGte = 4
        static private let daysOffset = 14
        
        static private func randomShortBy() -> String {
            let randomShortBy = validShortBy.randomElement() ?? .popularity
            let randomShortDirection = SortDirection.allCases.randomElement() ?? .asc
            return "\(randomShortBy.rawValue)\(randomShortDirection.rawValue)"
        }
        
        static private func currentDateString(daysOffset: Int = 0) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            guard let modifiedDate = Calendar.current.date(byAdding: .day, value: daysOffset, to: Date()) else {
                return .empty
            }
            return dateFormatter.string(from: modifiedDate)
        }
        
        static let headerFields: [String : String] = [
            HTTP.Header.Field.accept.rawValue: HTTP.Header.Value.applicationJson.description,
            HTTP.Header.Field.authorization.rawValue: HTTP.Header.Value.bearer(.movieDB).description
        ]
        
        static func mediaDataUrl(type: FetchType, locale: Locale, searchText: String?) throws -> URL {
            var urlString: String = ""
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: QueryParams.language.rawValue, value: locale.language))
            switch type {
            case .cinemaPlaying:
                urlString = "\(dataUrl)\(nowPlaying)"
                queryItems.append(URLQueryItem(name: QueryParams.region.rawValue, value: locale.region))
            case .cinemaUpcomimg:
                urlString = "\(dataUrl)\(upcoming)"
                queryItems.append(URLQueryItem(name: QueryParams.region.rawValue, value: locale.region))
            case .movieTrending:
                urlString = "\(dataUrl)\(trending)\(MediaType.movie)/\(MediaPeriod.day)"
            case .movieNew:
                urlString = "\(dataUrl)\(discover)\(MediaType.movie)"
                queryItems.append(URLQueryItem(name: "\(QueryParams.releaseDate.rawValue)\(QueryDirection.gte.rawValue)", value: currentDateString(daysOffset: -daysOffset)))
                queryItems.append(URLQueryItem(name: "\(QueryParams.releaseDate.rawValue)\(QueryDirection.lte.rawValue)", value: currentDateString(daysOffset: daysOffset*2)))
                queryItems.append(URLQueryItem(name: QueryParams.sortBy.rawValue, value: "\(SortBy.releaseDate.rawValue)\(SortDirection.asc.rawValue)"))
                queryItems.append(URLQueryItem(name: QueryParams.watchRegion.rawValue, value: locale.region))
                queryItems.append(URLQueryItem(name: QueryParams.withWatchMonetizationTypes.rawValue, value: MonetizationType.flatrate.rawValue))
                queryItems.append(URLQueryItem(name: "\(QueryParams.voteCount.rawValue)\(QueryDirection.gte.rawValue)", value: String(voteCountNewGte)))
            case .tvTrending:
                urlString = "\(dataUrl)\(trending)\(MediaType.tv)/\(MediaPeriod.day)"
            case .tvNew:
                urlString = "\(dataUrl)\(discover)\(MediaType.tv)"
                queryItems.append(URLQueryItem(name: "\(QueryParams.firstAirDate.rawValue)\(QueryDirection.gte.rawValue)", value: currentDateString(daysOffset: -daysOffset)))
                queryItems.append(URLQueryItem(name: "\(QueryParams.firstAirDate.rawValue)\(QueryDirection.lte.rawValue)", value: currentDateString(daysOffset: daysOffset*2)))
                queryItems.append(URLQueryItem(name: QueryParams.sortBy.rawValue, value: "\(SortBy.firstAirDate.rawValue)\(SortDirection.asc.rawValue)"))
                queryItems.append(URLQueryItem(name: QueryParams.watchRegion.rawValue, value: locale.region))
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
        
        var localized: LocalizedStringResource {
            switch self {
            case .cinemaPlaying: LocalizableString.homeSectionCinemaPlaying
            case .cinemaUpcomimg: LocalizableString.homeSectionCinemaUpcomimg
            case .movieTrending: LocalizableString.homeSectionMovieTrending
            case .movieNew: LocalizableString.homeSectionMovieNew
            case .tvTrending: LocalizableString.homeSectionTvTrending
            case .tvNew: LocalizableString.homeSectionTvNew
            case .personTrending: LocalizableString.homeSectionPersonTrending
            case .personPopular: LocalizableString.homeSectionPersonPopular
            case .trendingAll: ""
            case .searchAll: ""
            case .randomMovies: LocalizableString.homeSectionRandomMovies
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
    
    static func getRequest(type: FetchType, locale: Locale, searchText: String?) throws -> URLRequest {
        return HTTP.request(url: try Endpoint.mediaDataUrl(type: type, locale: locale, searchText: searchText), method: .get, fields: Endpoint.headerFields)
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
        case quiz(String, String),
             text(String)
        
        var description: String {
            switch self {
            case .quiz(let movies, let language):
                return
    """
    Give me a just a valid JSON Array of following structure, each one, about one of these movies (no 'movies' field, no 'data' field, just array): \(movies).
    
    Field 1: 'question' (String), a very difficult and original question whose answer is true or false (Ensure that the number of true answers is roughly equal to the number of false answers), about the corresponding movie, in '\(language)' language
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
    
    static func quizPrompt(movies: String, language: String) -> String {
        return
"""
Give me a just a valid JSON Array of following structure, each one, about one of these movies (no 'movies' field, no 'data' field, just array): \(movies).

Field 1: 'question' (String), a very difficult and original question whose answer is true or false (Ensure that the number of true answers is roughly equal to the number of false answers), about the corresponding movie, in '\(language)' language
Field 2: 'result' (Boolean), the answer of the previous question, which can only be true or false
"""
    }
    
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
