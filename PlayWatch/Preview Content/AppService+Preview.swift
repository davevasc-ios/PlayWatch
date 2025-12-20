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
        
        let mediaRepositoryPreview = MediaRepositoryPreview()
        
        let gameUtility = GameUtility(
            movieDBUtility: mediaRepositoryPreview,
            quizUtility: quizUtilityPreview
        )
        
        let mediaService = MediaService(
            movieDBUtility: mediaRepositoryPreview,
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
