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
}
