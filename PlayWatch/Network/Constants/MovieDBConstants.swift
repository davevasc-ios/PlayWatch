//
//  MovieDBConstants.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

struct MovieDBConstants {
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let baseImageURL = "https://image.tmdb.org/t/p/"
    
    static let paths: [MediaFetchType: String] = [
        .cinemaPlaying: "\(MovieDBType.movie)/now_playing",
        .cinemaUpcomimg: "\(MovieDBType.movie)/upcoming",
        .movieTrending: "trending/\(MovieDBType.movie)/day",
        .movieNew: "discover/\(MovieDBType.movie)",
        .tvTrending: "trending/\(MovieDBType.tv)/day",
        .tvNew: "discover/\(MovieDBType.tv)",
        .personTrending: "trending/\(MovieDBType.person)/day",
        .personPopular: "\(MovieDBType.person)/popular",
        .trendingAll: "trending/\(MovieDBType.all)/day",
        .searchAll: "search/multi",
        .randomMovies: "discover/\(MovieDBType.movie)"
    ]
    
    static let maxPages = 500
    static let voteAverageGte = 5
    static let voteCountQuizGte = 100
    static let voteCountNewGte = 4
    static let daysOffset = 14
    
    static let validShortBy: Set<MovieDBSorting.SortBy> = [
        .popularity,
        .revenue,
        .voteAverage,
        .voteCount
    ]
}
