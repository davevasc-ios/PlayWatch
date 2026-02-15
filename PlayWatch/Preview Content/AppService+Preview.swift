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
        
        let quizRepositoryPreview = QuizRepositoryPreview()
        
        let mediaRepositoryPreview = MediaRepositoryPreview()
        
        let gameUtility = GameUtility(
            mediaRepository: mediaRepositoryPreview,
            quizRepository: quizRepositoryPreview
        )
        
        let mediaService = MediaService(
            mediaRepository: mediaRepositoryPreview,
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
