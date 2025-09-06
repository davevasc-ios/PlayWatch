//
//  AppViewModel+Preview.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation

extension AppViewModel {
    static var preview: AppViewModel {
        
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
        
        return AppViewModel(
            homeModelLogic: homeLogic,
            gameModelLogic: gameLogic,
            settingsModelLogic: settingsLogic
        )
    }
}
