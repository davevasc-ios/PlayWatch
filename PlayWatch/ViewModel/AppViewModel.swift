//
//  AppViewModel.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Observation

@Observable
final class AppViewModel {
    let homeModelLogic: HomeModelLogic
    let gameModelLogic: GameModelLogic
    var settingsModelLogic: SettingsModelLogic
    
    init(
        homeModelLogic: HomeModelLogic,
        gameModelLogic: GameModelLogic,
        settingsModelLogic: SettingsModelLogic
    ) {
        self.homeModelLogic = homeModelLogic
        self.gameModelLogic = gameModelLogic
        self.settingsModelLogic = settingsModelLogic
    }
}

extension AppViewModel {
    static var production: AppViewModel {
        
        let settingsUtility = SettingsUtility()
        
        let movieDBEndpoint = MovieDBEndpoint(
            settingsUtility: settingsUtility
        )
        
        let mediaRequestProvider = MediaRequestProvider(
            movieDBendpoint: movieDBEndpoint
        )
        
        let aiRequestProvider = AIRequestProvider()

        let quizUtility = QuizUtility(
            settingsUtility: settingsUtility,
            aiRequestProvider: aiRequestProvider
        )
        
        let mediaUtility = MediaUtility(
            mediaRequestProvider: mediaRequestProvider
        )
        
        let gameUtility = GameUtility(
            movieDBUtility: mediaUtility,
            quizUtility: quizUtility
        )

        let homeLogic = HomeModelLogic(
            movieDBUtility: mediaUtility
        )
        
        let gameLogic = GameModelLogic(
            gameUtility: gameUtility
        )
        
        let settingsLogic = SettingsModelLogic(
            settingsUtility: settingsUtility
        )
                
        return AppViewModel(
            homeModelLogic: homeLogic,
            gameModelLogic: gameLogic,
            settingsModelLogic: settingsLogic
        )
    }
}
