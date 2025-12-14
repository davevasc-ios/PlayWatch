//
//  MediaFetchType.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

enum MediaFetchType {
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
    
    var type: SectionType {
        switch self {
        case .cinemaPlaying: SectionType.cinemaPlaying
        case .cinemaUpcomimg: SectionType.cinemaUpcomimg
        case .movieTrending: SectionType.movieTrending
        case .movieNew: SectionType.movieNew
        case .tvTrending: SectionType.tvTrending
        case .tvNew: SectionType.tvNew
        case .personTrending: SectionType.personTrending
        case .personPopular: SectionType.personPopular
        case .trendingAll: SectionType.randomMovies // TODO: -
        case .searchAll: SectionType.randomMovies // TODO: -
        case .randomMovies: SectionType.randomMovies
        }
    }
}
