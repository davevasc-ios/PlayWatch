//
//  MovieDBSorting.swift
//  PlayWatch
//
//  Created by David on 28/1/25.
//

import Foundation

struct MovieDBSorting {
    
    enum SortBy: String {
        case orignalTitle = "original_title",
             popularity,
             revenue,
             releaseDate = "primary_release_date",
             title,
             voteAverage = "vote_average",
             voteCount = "vote_count",
             firstAirDate = "first_air_date"
    }
    
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
}
