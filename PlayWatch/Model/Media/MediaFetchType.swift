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
    
    var testResource: String {
        switch self {
        case .randomMovies, .cinemaPlaying, .cinemaUpcomimg, .movieTrending, .movieNew:
            return Constants.Resource.Name.movies
        case .tvTrending, .tvNew:
            return Constants.Resource.Name.tvShows
        case .personTrending, .personPopular:
            return Constants.Resource.Name.people
        default:
            return Constants.Resource.Name.all
        }
    }
}
