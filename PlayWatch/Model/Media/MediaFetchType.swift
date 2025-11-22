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
        case .cinemaPlaying: Localizable.Home.sectionCinemaPlaying
        case .cinemaUpcomimg: Localizable.Home.sectionCinemaUpcomimg
        case .movieTrending: Localizable.Home.sectionMovieTrending
        case .movieNew: Localizable.Home.sectionMovieNew
        case .tvTrending: Localizable.Home.sectionTvTrending
        case .tvNew: Localizable.Home.sectionTvNew
        case .personTrending: Localizable.Home.sectionPersonTrending
        case .personPopular: Localizable.Home.sectionPersonPopular
        case .trendingAll: .empty
        case .searchAll: .empty
        case .randomMovies: Localizable.Home.sectionRandomMovies
        }
    }
}
