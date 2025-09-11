//
//  LocalizableString.swift
//  PlayWatch
//
//  Created by David on 3/5/24.
//

import Foundation

struct LocalizableString {
    
    // MARK: - Table LocalizableTabBar
    static let home = LocalizedStringResource(
        "tabbar.home",
        defaultValue: "Home",
        table: "LocalizableTabBar",
        comment: "Home section name of TabBar"
    )
    static let game = LocalizedStringResource(
        "tabbar.game",
        defaultValue: "Game",
        table: "LocalizableTabBar",
        comment: "Game section of TabBar"
    )
    static let favorites = LocalizedStringResource(
        "tabbar.favorites",
        defaultValue: "Favorites",
        table: "LocalizableTabBar",
        comment: "Favorites section of TabBar"
    )
    static let settings = LocalizedStringResource(
        "tabbar.settings",
        defaultValue: "Settings",
        table: "LocalizableTabBar",
        comment: "Settings section of TabBar"
    )
    static let search = LocalizedStringResource(
        "tabbar.search",
        defaultValue: "Search",
        table: "LocalizableTabBar",
        comment: "Search section of TabBar"
    )
    
    // MARK: - Table LocalizableHome
    static let homeSearchBar = LocalizedStringResource(
        "home.searchBar.placeholder",
        defaultValue: "Search by movie, tv or person",
        table: "LocalizableHome",
        comment: "Placeholder of search bar"
    )
    static let homeSectionCinemaPlaying = LocalizedStringResource(
        "home.section.cinemaPlaying",
        defaultValue: "Cinema Playing",
        table: "LocalizableHome",
        comment: "Home section name of cinema playing"
    )
    static let homeSectionCinemaUpcomimg = LocalizedStringResource(
        "home.section.cinemaUpcomimg",
        defaultValue: "Upcoming Movies",
        table: "LocalizableHome",
        comment: "Home section name of cinema upcomimg"
    )
    static let homeSectionMovieTrending = LocalizedStringResource(
        "home.section.movieTrending",
        defaultValue: "Trending Movies",
        table: "LocalizableHome",
        comment: "Home section name of movie trending"
    )
    static let homeSectionMovieNew = LocalizedStringResource(
        "home.section.movieNew",
        defaultValue: "New Movies",
        table: "LocalizableHome",
        comment: "Home section name of new movies"
    )
    static let homeSectionTvTrending = LocalizedStringResource(
        "home.section.tvTrending",
        defaultValue: "Trending TV Shows",
        table: "LocalizableHome",
        comment: "Home section name of trending tv shows"
    )
    static let homeSectionTvNew = LocalizedStringResource(
        "home.section.tvNew",
        defaultValue: "New TV Shows",
        table: "LocalizableHome",
        comment: "Home section name of new tv shows"
    )
    static let homeSectionPersonTrending = LocalizedStringResource(
        "home.section.personTrending",
        defaultValue: "Trending Persons",
        table: "LocalizableHome",
        comment: "Home section name of trending persons"
    )
    static let homeSectionPersonPopular = LocalizedStringResource(
        "home.section.personPopular",
        defaultValue: "Popular Persons",
        table: "LocalizableHome",
        comment: "Home section name of popular persons"
    )
    static let homeSectionRandomMovies = LocalizedStringResource(
        "home.section.randomMovies",
        defaultValue: "Random Movies",
        table: "LocalizableHome",
        comment: "Home section name of random movies"
    )
    
    // MARK: - Table LocalizableSettings
    static let systemLanguageName = LocalizedStringResource(
        "settings.language.system",
        defaultValue: "Automatic",
        table: "LocalizableSettings",
        comment: "Automatic language name"
    )
    static let englishLanguageName = LocalizedStringResource(
        "settings.language.english",
        defaultValue: "English",
        table: "LocalizableSettings",
        comment: "English language name"
    )
    static let spanishLanguageName = LocalizedStringResource(
        "settings.language.spanish",
        defaultValue: "Spanish",
        table: "LocalizableSettings",
        comment: "Spanish language name"
    )
    static let basqueLanguageName = LocalizedStringResource(
        "settings.language.basque",
        defaultValue: "Basque",
        table: "LocalizableSettings",
        comment: "Basque language name"
    )
    static let catalanLanguageName = LocalizedStringResource(
        "settings.language.catalan",
        defaultValue: "Catalan",
        table: "LocalizableSettings",
        comment: "Catalan language name"
    )
    static let frenchLanguageName = LocalizedStringResource(
        "settings.language.french",
        defaultValue: "French",
        table: "LocalizableSettings",
        comment: "French language name"
    )
    static let italianLanguageName = LocalizedStringResource(
        "settings.language.italian",
        defaultValue: "Italian",
        table: "LocalizableSettings",
        comment: "Italian language name"
    )
    static let portugueseLanguageName = LocalizedStringResource(
        "settings.language.portuguese",
        defaultValue: "Portuguese",
        table: "LocalizableSettings",
        comment: "Portuguese language name"
    )
    static let germanLanguageName = LocalizedStringResource(
        "settings.language.german",
        defaultValue: "German",
        table: "LocalizableSettings",
        comment: "German language name"
    )
    static let systemRegionName = LocalizedStringResource(
        "settings.region.system",
        defaultValue: "Automatic",
        table: "LocalizableSettings",
        comment: "Automatic region name"
    )
    static let unitedStatesRegionName = LocalizedStringResource(
        "settings.region.unitedStates",
        defaultValue: "United States",
        table: "LocalizableSettings",
        comment: "United States region name"
    )
    static let unitedKingdomRegionName = LocalizedStringResource(
        "settings.region.unitedKingdom",
        defaultValue: "United Kingdom",
        table: "LocalizableSettings",
        comment: "United Kingdom region name"
    )
    static let spainRegionName = LocalizedStringResource(
        "settings.region.spain",
        defaultValue: "Spain",
        table: "LocalizableSettings",
        comment: "Spain region name"
    )
    static let basqueCountryRegionName = LocalizedStringResource(
        "settings.region.basqueCountry",
        defaultValue: "Basque Country",
        table: "LocalizableSettings",
        comment: "Basque Country region name"
    )
    static let cataloniaRegionName = LocalizedStringResource(
        "settings.region.catalonia",
        defaultValue: "Catalonia",
        table: "LocalizableSettings",
        comment: "Catalonia region name"
    )
    static let mexicoRegionName = LocalizedStringResource(
        "settings.region.mexico",
        defaultValue: "Mexico",
        table: "LocalizableSettings",
        comment: "Mexico region name"
    )
    static let franceRegionName = LocalizedStringResource(
        "settings.region.france",
        defaultValue: "France",
        table: "LocalizableSettings",
        comment: "France region name"
    )
    static let italyRegionName = LocalizedStringResource(
        "settings.region.italy",
        defaultValue: "Italy",
        table: "LocalizableSettings",
        comment: "Italy region name"
    )
    static let portugalRegionName = LocalizedStringResource(
        "settings.region.portugal",
        defaultValue: "Portugal",
        table: "LocalizableSettings",
        comment: "Portugal region name"
    )
    static let brazilRegionName = LocalizedStringResource(
        "settings.region.brazil",
        defaultValue: "Brazil",
        table: "LocalizableSettings",
        comment: "Brazil region name"
    )
    static let germanyRegionName = LocalizedStringResource(
        "settings.region.germany",
        defaultValue: "Germany",
        table: "LocalizableSettings",
        comment: "Germany region name"
    )
}
