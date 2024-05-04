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
    
    // MARK: - Table LocalizableHome
    static let title = LocalizedStringResource(
        "home.section.title",
        defaultValue: "Home",
        table: "LocalizableHome",
        comment: "Home section name of TabBar"
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
}
