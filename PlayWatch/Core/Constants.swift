//
//  Constants.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation
import SwiftUI

enum Constants {
    
    enum AIServer: String, CaseIterable, Identifiable {
        case openAI = "OpenAI"
        case gemini = "Gemini"
        
        var id: Self { self }
        
        var testResource: String {
            switch self {
            case .openAI: Constants.Resource.Name.openAIResponse
            case .gemini: Constants.Resource.Name.geminiAIResponse
            }
        }
        
        func decodeQuizResponse(from data: Data) throws -> String {
            switch self {
            case .openAI: try OpenAIResponse.decode(from: data).aiResponseText
            case .gemini: try GeminiResponse.decode(from: data).aiResponseText
            }
        }
    }
    
    enum Game {
        static let screenCutoffScale: CGFloat = 0.8 / 2
        static let questionHeightScale: CGFloat = 0.15
        static let quizWidhtScale: CGFloat = 0.65
        static let quizCardDegrees: CGFloat = 12
        static let typingTextIntervales: [UInt64] = [10000000, 40000000, 80000000, 160000000, 200000000]
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
    
    enum Resource {
        enum Name {
            static let all = "All"
            static let movies = "Movies"
            static let people = "People"
            static let tvShows = "TVShows"
            static let openAIResponse = "OpenAIResponse"
            static let geminiAIResponse = "GeminiAIResponse"
        }
        
        enum Extension {
            static let json = "json"
        }
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
            case .trendingAll: .empty
            case .searchAll: .empty
            case .randomMovies: LocalizableString.homeSectionRandomMovies
            }
        }
        
        var testResource: String {
            switch self {
            case .randomMovies, .cinemaPlaying, .cinemaUpcomimg, .movieTrending, .movieNew:
                return Constants.Resource.Name.movies
            case .tvTrending, .tvNew:
                return Constants.Resource.Name.tvShows
            case .personTrending, .personPopular:
                return Constants.Resource.Name.people
            default:
                return Constants.Resource.Name.all
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
    static func getImageUrl(file: String?, size: ImageSize) -> URL? {
        guard let file else { return nil }
        return URL(string: "\(MovieDBEndpoint.imageURL)\(size.rawValue)\(file)")
    }
    
    static func getDate(date: String?) -> Date? {
        guard let date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = self.dateFormat
        return formatter.date(from: date)
    }
}



struct OpenAI: Codable {
    
    static let endpoint = "https://api.openai.com/v1/chat/completions"
    static let systemModel = "gpt-3.5-turbo"
    
    static let headerFields:  [HTTP.Header.Field: HTTP.Header.Value] = [
        .contentType: .applicationJson,
        .authorization: .bearer(.openAI)
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
    
    static func request(type: UserPrompt) throws -> URLRequest {
        guard let url = URL(string: self.endpoint) else {
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
        return HTTP.request(url: url, method: .post, headers: self.headerFields, body: body)
    }
}


struct Gemini: Codable {
    
    static let systemModel = "gemini-pro"
    static let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/\(systemModel):generateContent?key=\(API.Key.gemini)"
    
    static func quizPrompt(_ movies: String, _ language: String) -> String {
"""
Give me a just a valid JSON Array of following structure, each one, about one of these movies (no 'movies' field, no 'data' field, just array): \(movies).

Field 1: 'question' (String), a very difficult and original question whose answer is true or false (Ensure that the number of true answers is roughly equal to the number of false answers), about the corresponding movie, in '\(language)' language
Field 2: 'result' (Boolean), the answer of the previous question, which can only be true or false
"""
    }
    
    static let headerFields:  [HTTP.Header.Field: HTTP.Header.Value] = [
        .contentType: .applicationJson
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
    
    static func request(text: String) throws -> URLRequest {
        guard let url = URL(string: endpoint) else {
            throw API.Error.invalidURL
        }
        let body = try? JSONEncoder().encode(Body(contents: Content(parts: Part(text: text))))
        return HTTP.request(url: url, method: .post, headers: self.headerFields, body: body)
    }
    
}
