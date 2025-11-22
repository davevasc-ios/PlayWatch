//
//  LocalizableHome.swift
//  PlayWatch
//
//  Created by David on 22/11/25.
//

import Foundation

extension Localizable {
    
    // MARK: - Table LocalizableHome
    enum Home {
        
        static let title = LocalizedStringResource(
            "home.section.title",
            defaultValue: "Home",
            table: "LocalizableHome",
            comment: "Home section title"
        )
        static let sectionCinemaPlaying = LocalizedStringResource(
            "home.section.cinemaPlaying",
            defaultValue: "Cinema Playing",
            table: "LocalizableHome",
            comment: "Home section name of cinema playing"
        )
        static let sectionCinemaUpcomimg = LocalizedStringResource(
            "home.section.cinemaUpcomimg",
            defaultValue: "Upcoming Movies",
            table: "LocalizableHome",
            comment: "Home section name of cinema upcomimg"
        )
        static let sectionMovieTrending = LocalizedStringResource(
            "home.section.movieTrending",
            defaultValue: "Trending Movies",
            table: "LocalizableHome",
            comment: "Home section name of movie trending"
        )
        static let sectionMovieNew = LocalizedStringResource(
            "home.section.movieNew",
            defaultValue: "New Movies",
            table: "LocalizableHome",
            comment: "Home section name of new movies"
        )
        static let sectionTvTrending = LocalizedStringResource(
            "home.section.tvTrending",
            defaultValue: "Trending TV Shows",
            table: "LocalizableHome",
            comment: "Home section name of trending tv shows"
        )
        static let sectionTvNew = LocalizedStringResource(
            "home.section.tvNew",
            defaultValue: "New TV Shows",
            table: "LocalizableHome",
            comment: "Home section name of new tv shows"
        )
        static let sectionPersonTrending = LocalizedStringResource(
            "home.section.personTrending",
            defaultValue: "Trending Persons",
            table: "LocalizableHome",
            comment: "Home section name of trending persons"
        )
        static let sectionPersonPopular = LocalizedStringResource(
            "home.section.personPopular",
            defaultValue: "Popular Persons",
            table: "LocalizableHome",
            comment: "Home section name of popular persons"
        )
        static let sectionRandomMovies = LocalizedStringResource(
            "home.section.randomMovies",
            defaultValue: "Random Movies",
            table: "LocalizableHome",
            comment: "Home section name of random movies"
        )
    }
}
