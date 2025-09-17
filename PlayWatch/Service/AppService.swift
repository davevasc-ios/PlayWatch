//
//  AppService.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Observation

@Observable
final class AppService {
    let mediaService: MediaService
    let gameService: GameService
    var preferencesService: PreferencesService
    
    init(
        mediaService: MediaService,
        gameService: GameService,
        preferencesService: PreferencesService
    ) {
        self.mediaService = mediaService
        self.gameService = gameService
        self.preferencesService = preferencesService
    }
}

extension AppService {
    static var production: AppService {
        
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

        let mediaService = MediaService(
            movieDBUtility: mediaUtility
        )
        
        let gameService = GameService(
            gameUtility: gameUtility
        )
        
        let preferencesService = PreferencesService(
            settingsUtility: settingsUtility
        )
                
        return AppService(
            mediaService: mediaService,
            gameService: gameService,
            preferencesService: preferencesService
        )
    }
}
