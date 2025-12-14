//
//  Constants.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

struct Constants {
    
    enum DateFormatType: String {
        case repository = "yyyy-MM-dd"
        case display = "dd/MM/yyyy"
    }
    
    static let homeSections: [MediaFetchType] = [
        .cinemaUpcomimg,
        .randomMovies,
        .cinemaPlaying,
        .cinemaUpcomimg,
        .movieTrending,
        .movieNew,
        .tvTrending,
        .tvNew,
        .personTrending,
        .personPopular
    ]
    
}

enum SectionType: Identifiable, Hashable {
    case hero
    case randomMovies
    case cinemaPlaying
    case cinemaUpcomimg
    case movieTrending
    case movieNew
    case tvTrending
    case tvNew
    case personTrending
    case personPopular
    case gameTrending
    
    var id: Self { self }
    
    var title: LocalizedStringResource { self.localized }
    
    var localized: LocalizedStringResource {
        switch self {
        case .hero: "Destacados" // TODO: -
        case .randomMovies: Localizable.Home.sectionRandomMovies
        case .cinemaPlaying: Localizable.Home.sectionCinemaPlaying
        case .cinemaUpcomimg: Localizable.Home.sectionCinemaUpcomimg
        case .movieTrending: Localizable.Home.sectionMovieTrending
        case .movieNew: Localizable.Home.sectionMovieNew
        case .tvTrending: Localizable.Home.sectionTvTrending
        case .tvNew: Localizable.Home.sectionTvNew
        case .personTrending: Localizable.Home.sectionPersonTrending
        case .personPopular: Localizable.Home.sectionPersonPopular
        case .gameTrending: Localizable.Home.sectionRandomMovies // TODO: -
        }
    }
}
