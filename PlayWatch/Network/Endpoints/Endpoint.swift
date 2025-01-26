//
//  Endpoint.swift
//  PlayWatch
//
//  Created by David on 22/1/25.
//

import Foundation

protocol BaseEndpointProtocol: Sendable {
    var baseURL: String { get }
    var method: HTTP.Method { get }
    var headers: [HTTP.Header.Field: HTTP.Header.Value] { get }
}
protocol MediaEndpointProtocol: BaseEndpointProtocol {
    func path(type: MovieDB.FetchType) -> String?
    func queryItems(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) -> [URLQueryItem]
}
protocol AIEndpointProtocol: BaseEndpointProtocol {
    var apiKey: String? { get }
    func body(movies: String, language: String) throws -> Data?
}

extension MediaEndpointProtocol {
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        let url = try HTTP.url(
            baseURL: self.baseURL,
            path: self.path(type: config.mediaType),
            queryItems: self.queryItems(type: config.mediaType, locale: config.locale, searchText: config.searchQuery)
        )
        return HTTP.request(
            url: url,
            method: self.method.rawValue,
            headers: self.headers.toHTTPHeaderFields
        )
    }
}

protocol AIEndpointFactoryProtocol {
    func resolveEndpoint(for aiServer: Constants.AIServer) -> AIEndpointProtocol
}

struct AIEndpointFactory: AIEndpointFactoryProtocol {
    func resolveEndpoint(for aiServer: Constants.AIServer) -> AIEndpointProtocol {
        switch aiServer {
        case .openAI: OpenAIEndpoint()
        case .gemini: GeminiEndpoint()
        }
    }
}

extension AIEndpointProtocol {
    func createRequest(movies: String, language: String) throws -> URLRequest {
        HTTP.request(
            url: try HTTP.url(baseURL: self.baseURL, apiKey: self.apiKey),
            method: self.method.rawValue,
            headers: self.headers.toHTTPHeaderFields,
            body: try self.body(movies: movies, language: language)
        )
    }
}

struct MovieDBEndpoint: MediaEndpointProtocol {
    
    // MARK: - Constants
    static let imageURL = "https://image.tmdb.org/t/p/"
    let paths: [MovieDB.FetchType: String] = [
        .cinemaPlaying: "\(MediaType.movie)/now_playing",
        .cinemaUpcomimg: "\(MediaType.movie)/upcoming",
        .movieTrending: "trending/\(MediaType.movie)/day",
        .movieNew: "discover/\(MediaType.movie)",
        .tvTrending: "trending/\(MediaType.tv)/day",
        .tvNew: "discover/\(MediaType.tv)",
        .personTrending: "trending/\(MediaType.person)/day",
        .personPopular: "\(MediaType.person)/popular",
        .trendingAll: "trending/\(MediaType.all)/day",
        .searchAll: "search/multi",
        .randomMovies: "discover/\(MediaType.movie)"
    ]
    let maxPages = 500
    let voteAverageGte = 5
    let voteCountQuizGte = 100
    let voteCountNewGte = 4
    let daysOffset = 14
    
    // MARK: - Protocol implementation
    let baseURL = "https://api.themoviedb.org/3/"
    func path(type: MovieDB.FetchType) -> String? {
        self.paths[type]
    }
    func queryItems(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: MovieDB.QueryParams.language.rawValue, value: locale.language)
        ]
        switch type {
        case .cinemaPlaying, .cinemaUpcomimg:
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.region.rawValue, value: locale.region))
        case .movieNew, .tvNew:
            queryItems.append(URLQueryItem(name: "\(type == .movieNew ? MovieDB.QueryParams.releaseDate.rawValue : MovieDB.QueryParams.firstAirDate.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: Date().toString(daysOffset: -daysOffset)))
            queryItems.append(URLQueryItem(name: "\(type == .movieNew ? MovieDB.QueryParams.releaseDate.rawValue : MovieDB.QueryParams.firstAirDate.rawValue)\(MovieDB.QueryDirection.lte.rawValue)", value: Date().toString(daysOffset: daysOffset*2)))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.sortBy.rawValue, value: "\(type == .movieNew ? MovieDB.SortBy.releaseDate.rawValue : MovieDB.SortBy.firstAirDate.rawValue)\(MovieDB.SortDirection.asc.rawValue)"))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.watchRegion.rawValue, value: locale.region))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.withWatchMonetizationTypes.rawValue, value: MovieDB.MonetizationType.flatrate.rawValue))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.voteCount.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: String(voteCountNewGte)))
        case .searchAll:
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.query.rawValue, value: searchText.orEmpty))
        case .randomMovies:
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.page.rawValue, value: String(Int.random(in: 1...maxPages))))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.releaseDate.rawValue)\(MovieDB.QueryDirection.lte.rawValue)", value: Date().toString()))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.sortBy.rawValue, value: RandomUtils.randomShortBy))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.voteAverage.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: String(voteAverageGte)))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.voteCount.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: String(voteCountQuizGte)))
        default: break
        }
        return queryItems
    }
    let method: HTTP.Method = .get
    let headers: [HTTP.Header.Field: HTTP.Header.Value] = [
        .accept: .applicationJson,
        .authorization: .bearer(.movieDB)
    ]
}

struct OpenAIEndpoint: AIEndpointProtocol {
    let baseURL: String = "https://api.openai.com/v1/chat/completions"
    let apiKey: String? = nil
    let method: HTTP.Method = .post
    let headers: [HTTP.Header.Field : HTTP.Header.Value] = [
        .contentType: .applicationJson,
        .authorization: .bearer(.openAI)
    ]
    func body(movies: String, language: String) throws -> Data? {
        try OpenAIBody.encode(movies: movies, language: language)
    }
}

struct GeminiEndpoint: AIEndpointProtocol {
    let baseURL: String = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    let apiKey: String? = API.Key.gemini.description
    let method: HTTP.Method = .post
    let headers: [HTTP.Header.Field : HTTP.Header.Value] = [
        .contentType: .applicationJson
    ]
    func body(movies: String, language: String) throws -> Data? {
        try GeminiBody.encode(movies: movies, language: language)
    }
}
