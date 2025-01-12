//
//  MovieDBEndpoint.swift
//  PlayWatch
//
//  Created by David on 11/1/25.
//

import Foundation

struct MovieDBEndpoint {
    
    // MARK: - Data
    static private let version = 3
    static private let baseURL = "https://api.themoviedb.org/\(String(version))/"
    static let imageURL = "https://image.tmdb.org/t/p/"
    
    static let paths: [MovieDB.FetchType: String] = [
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
    
    static func url(for type: MovieDB.FetchType) -> String {
        return paths[type].map { "\(self.baseURL)\($0)" }.orEmpty
    }
    
    static private let maxPages = 500
    static private let voteAverageGte = 5
    static private let voteCountQuizGte = 100
    static private let voteCountNewGte = 4
    static private let daysOffset = 14
    
    static private func randomShortBy() -> String {
        let randomShortBy = MovieDB.validShortBy.randomElement() ?? .popularity
        let randomShortDirection = MovieDB.SortDirection.allCases.randomElement() ?? .asc
        return "\(randomShortBy.rawValue)\(randomShortDirection.rawValue)"
    }
    
    static private func currentDateString(daysOffset: Int = 0) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = MovieDB.dateFormat
        guard let modifiedDate = Calendar.current.date(byAdding: .day, value: daysOffset, to: Date()) else {
            return .empty
        }
        return dateFormatter.string(from: modifiedDate)
    }
    
    static let headerFields: [HTTP.Header.Field: HTTP.Header.Value] = [
        .accept: .applicationJson,
        .authorization: .bearer(.movieDB)
    ]
    
    static func mediaDataUrl(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) throws -> URL {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: MovieDB.QueryParams.language.rawValue, value: locale.language))
        
        switch type {
        case .cinemaPlaying:
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.region.rawValue, value: locale.region))
        case .cinemaUpcomimg:
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.region.rawValue, value: locale.region))
        case .movieNew:
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.releaseDate.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: currentDateString(daysOffset: -daysOffset)))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.releaseDate.rawValue)\(MovieDB.QueryDirection.lte.rawValue)", value: currentDateString(daysOffset: daysOffset*2)))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.sortBy.rawValue, value: "\(MovieDB.SortBy.releaseDate.rawValue)\(MovieDB.SortDirection.asc.rawValue)"))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.watchRegion.rawValue, value: locale.region))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.withWatchMonetizationTypes.rawValue, value: MovieDB.MonetizationType.flatrate.rawValue))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.voteCount.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: String(self.voteCountNewGte)))
        case .tvNew:
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.firstAirDate.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: currentDateString(daysOffset: -daysOffset)))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.firstAirDate.rawValue)\(MovieDB.QueryDirection.lte.rawValue)", value: currentDateString(daysOffset: daysOffset*2)))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.sortBy.rawValue, value: "\(MovieDB.SortBy.firstAirDate.rawValue)\(MovieDB.SortDirection.asc.rawValue)"))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.watchRegion.rawValue, value: locale.region))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.withWatchMonetizationTypes.rawValue, value: MovieDB.MonetizationType.flatrate.rawValue))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.voteCount.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: String(self.voteCountNewGte)))
        case .searchAll:
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.query.rawValue, value: searchText.orEmpty))
        case .randomMovies:
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.page.rawValue, value: String(Int.random(in: 1...maxPages))))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.releaseDate.rawValue)\(MovieDB.QueryDirection.lte.rawValue)", value: currentDateString()))
            queryItems.append(URLQueryItem(name: MovieDB.QueryParams.sortBy.rawValue, value: self.randomShortBy()))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.voteAverage.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: String(voteAverageGte)))
            queryItems.append(URLQueryItem(name: "\(MovieDB.QueryParams.voteCount.rawValue)\(MovieDB.QueryDirection.gte.rawValue)", value: String(voteCountQuizGte)))
        default: break
        }
        
        guard let url = URL(string: self.url(for: type)),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw API.Error.invalidURL
        }
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        guard let finalURL = components.url else {
            throw API.Error.invalidURL
        }
        return finalURL
    }
}
