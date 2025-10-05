//
//  AppService+Preview.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation

extension AppService {
    static var preview: AppService {
        
        let settingsUtilityPreview = SettingsUtilityPreview()
        
        let preferencesService = PreferencesService(
            settingsUtility: settingsUtilityPreview
        )
        
        let quizUtilityPreview = QuizUtilityPreview()
        
        let mediaUtilityPreview = MediaUtilityPreview()
        
        let gameUtility = GameUtility(
            movieDBUtility: mediaUtilityPreview,
            quizUtility: quizUtilityPreview
        )
        
        let mediaService = MediaService(
            movieDBUtility: mediaUtilityPreview,
            mediaLocaleProvider: preferencesService
        )
        
        let gameService = GameService(
            gameUtility: gameUtility,
            gameDataProvider: preferencesService
        )
        
        
        
        return AppService(
            mediaService: mediaService,
            gameService: gameService,
            preferencesService: preferencesService
        )
    }
}
