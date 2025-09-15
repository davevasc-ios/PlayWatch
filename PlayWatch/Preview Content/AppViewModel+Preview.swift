//
//  AppViewModel+Preview.swift
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
        
        let homeLogic = HomeModelLogic(
            movieDBUtility: mediaUtilityPreview
        )
        
        let gameLogic = GameModelLogic(
            gameUtility: gameUtility
        )
        
        let settingsLogic = SettingsModelLogic(
            settingsUtility: settingsUtilityPreview
        )
        
        return AppService(
            homeModelLogic: homeLogic,
            gameModelLogic: gameLogic,
            settingsModelLogic: settingsLogic
        )
    }
}
