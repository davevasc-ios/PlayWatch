//
//  MediaEndpoints.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation


protocol MediaRequestProviding: Sendable {
    func createRequest(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) throws -> URLRequest
}

struct MediaRequestProvider: MediaRequestProviding {
    let movieDBendpoint: MovieDBEndpointProtocol

    func createRequest(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) throws -> URLRequest {
        try movieDBendpoint.createRequest(for: type, with: locale, searchQuery: searchQuery)
    }
}

protocol MovieDBEndpointProtocol: BaseEndpointProtocol {
    func queryItems(for type: MediaFetchType, with locale: MediaLocale, searchText: String?) -> [URLQueryItem]
}

extension MovieDBEndpointProtocol {
    var baseURL: String { MovieDBConstants.baseURL }
    var method: HTTP.Method { .get }
    var apiKey: API.Key { .movieDB }
    var headers: [HTTP.Header.Field: HTTP.Header.Value] {
        [.accept: .applicationJson,
         .authorization: .bearer(self.apiKey)]
    }
    var timeout: TimeInterval { 15 }
    
    func createRequest(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) throws -> URLRequest {
        let url = try HTTP.url(
            baseURL: self.baseURL,
            path: MovieDBConstants.paths[type],
            queryItems: self.queryItems(for: type, with: locale, searchText: searchQuery)
        )
        
        return HTTP.request(
            url: url,
            method: self.method,
            headers: self.headers,
            timeout: self.timeout
        )
    }
}


struct MovieDBEndpoint: MovieDBEndpointProtocol {    
    func queryItems(for type: MediaFetchType, with locale: MediaLocale, searchText: String?) -> [URLQueryItem] {
        self.resolveQueryItems(for: type, with: locale, searchText: searchText)
    }
}

// MARK: - MovieDB QueryItems
extension MovieDBEndpoint {
        
    private func resolveQueryItems(for type: MediaFetchType, with locale: MediaLocale, searchText: String?) -> [URLQueryItem] {
        [
            .init(.language, locale.language)
        ] + {
            switch type {
            case .cinemaPlaying, .cinemaUpcomimg:
                [.init(.region, locale.region)]
            case .movieNew, .tvNew:
                self.newQueryItems(for: type, with: locale.region)
            case .searchAll:
                [.init(.query, searchText.orEmpty)]
            case .randomMovies:
                self.randomQueryItems
            default:
                []
            }
        }()
    }
    
    private func newQueryItems(for type: MediaFetchType, with region: String) -> [URLQueryItem] {
        [
            .init(type == .movieNew ? .releaseDate : .firstAirDate, .gte, Date().toString(daysOffset: -MovieDBConstants.daysOffset)),
            .init(type == .movieNew ? .releaseDate : .firstAirDate, .lte, Date().toString(daysOffset: MovieDBConstants.daysOffset*2)),
            .init(.sortBy, type == .movieNew ? .releaseDate : .firstAirDate, .asc),
            .init(.watchRegion, region),
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
