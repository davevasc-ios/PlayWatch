//
//  MediaEndpoints.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

protocol MovieDBEndpointProtocol: BaseEndpointProtocol {
    func queryItems(type: MediaFetchType, searchText: String?) -> [URLQueryItem]
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
    
    func createRequest(mediaType: MediaFetchType, searchQuery: String?) throws -> URLRequest {
        let url = try HTTP.url(
            baseURL: self.baseURL,
            path: MovieDBConstants.paths[mediaType],
            queryItems: self.queryItems(type: mediaType, searchText: searchQuery)
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
    let settingsUtility: SettingsReadable
    
    func queryItems(type: MediaFetchType, searchText: String?) -> [URLQueryItem] {
        self.resolveQueryItems(type: type, searchText: searchText)
    }
}

// MARK: - MovieDB QueryItems
extension MovieDBEndpoint {
        
    private func resolveQueryItems(type: MediaFetchType, searchText: String?) -> [URLQueryItem] {
        [
            .init(.language, settingsUtility.mediaLocale.language)
        ] + {
            switch type {
            case .cinemaPlaying, .cinemaUpcomimg:
                [.init(.region, settingsUtility.mediaLocale.region)]
            case .movieNew, .tvNew:
                self.newQueryItems(type: type)
            case .searchAll:
                [.init(.query, searchText.orEmpty)]
            case .randomMovies:
                self.randomQueryItems
            default:
                []
            }
        }()
    }
    
    private func newQueryItems(type: MediaFetchType) -> [URLQueryItem] {
        [
            .init(type == .movieNew ? .releaseDate : .firstAirDate, .gte, Date().toString(daysOffset: -MovieDBConstants.daysOffset)),
            .init(type == .movieNew ? .releaseDate : .firstAirDate, .lte, Date().toString(daysOffset: MovieDBConstants.daysOffset*2)),
            .init(.sortBy, type == .movieNew ? .releaseDate : .firstAirDate, .asc),
            .init(.watchRegion, settingsUtility.mediaLocale.region),
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
