//
//  MediaEndpoints.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

protocol MediaEndpointProtocol: BaseEndpointProtocol {
    
    func path(type: MediaFetchType) -> String?
    func queryItems(type: MediaFetchType, locale: MediaLocale, searchText: String?) -> [URLQueryItem]
    func createRequest(config: MediaRequestConfig) throws -> URLRequest
}

struct MovieDBEndpoint: MediaEndpointProtocol {

    let baseURL = MovieDBConstants.baseURL
    let method: HTTP.Method = .get
    let apiKey: API.Key = .movieDB
    var headers: [HTTP.Header.Field: HTTP.Header.Value] {
        [.accept: .applicationJson,
         .authorization: .bearer(self.apiKey)]
    }
    let timeout: TimeInterval = 15
    
    func path(type: MediaFetchType) -> String? {
        MovieDBConstants.paths[type]
    }
    func queryItems(type: MediaFetchType, locale: MediaLocale, searchText: String?) -> [URLQueryItem] {
        self.resolveQueryItems(type: type, locale: locale, searchText: searchText)
    }
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        
        let url = try HTTP.url(
            baseURL: self.baseURL,
            path: self.path(type: config.mediaType),
            queryItems: self.queryItems(type: config.mediaType, locale: config.locale, searchText: config.searchQuery)
        )
        
        return HTTP.request(
            url: url,
            method: self.method,
            headers: self.headers,
            timeout: self.timeout
        )
    }
}

// MARK: - MovieDB QueryItems
extension MovieDBEndpoint {
        
    private func resolveQueryItems(type: MediaFetchType, locale: MediaLocale, searchText: String?) -> [URLQueryItem] {
        [
            .init(.language, locale.language)
        ] + {
            switch type {
            case .cinemaPlaying, .cinemaUpcomimg:
                [.init(.region, locale.region)]
            case .movieNew, .tvNew:
                self.newQueryItems(type: type, locale: locale)
            case .searchAll:
                [.init(.query, searchText.orEmpty)]
            case .randomMovies:
                self.randomQueryItems
            default:
                []
            }
        }()
    }
    
    private func newQueryItems(type: MediaFetchType, locale: MediaLocale) -> [URLQueryItem] {
        [
            .init(type == .movieNew ? .releaseDate : .firstAirDate, .gte, Date().toString(daysOffset: -MovieDBConstants.daysOffset)),
            .init(type == .movieNew ? .releaseDate : .firstAirDate, .lte, Date().toString(daysOffset: MovieDBConstants.daysOffset*2)),
            .init(.sortBy, type == .movieNew ? .releaseDate : .firstAirDate, .asc),
            .init(.watchRegion, locale.region),
            .init(.withWatchMonetizationTypes, .flatrate),
            .init(.voteCount, .gte, "\(MovieDBConstants.voteCountNewGte)")
        ]
    }
        
    private var randomQueryItems: [URLQueryItem] {
        [
            .init(.page, "\(Int.random(in: 1...MovieDBConstants.maxPages))"),
            .init(.releaseDate, .lte, Date().toString()),
            .init(.sortBy, MovieDBUtils.randomShortBy),
            .init(.voteAverage, .gte, "\(MovieDBConstants.voteAverageGte)"),
            .init(.voteCount, .gte, "\(MovieDBConstants.voteCountQuizGte)")
        ]
    }
}
