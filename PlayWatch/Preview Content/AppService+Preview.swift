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
        
        let quizUtilityPreview = QuizUtilityPreview(
            settingsUtility: settingsUtilityPreview
        )
        
        let mediaUtilityPreview = MediaUtilityPreview()
        
        let gameUtility = GameUtility(
            movieDBUtility: mediaUtilityPreview,
            quizUtility: quizUtilityPreview
        )
        
        let mediaService = MediaService(
            movieDBUtility: mediaUtilityPreview
        )
        
        let gameService = GameService(
            gameUtility: gameUtility
        )
        
        let preferencesService = PreferencesService(
            settingsUtility: settingsUtilityPreview
        )
        
        return AppService(
            mediaService: mediaService,
            gameService: gameService,
            preferencesService: preferencesService
        )
    }
}
