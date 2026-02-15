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
        
        let preferencesService = PreferencesService(
            settingsUtility: settingsUtility
        )
        
        let movieDBEndpoint = MovieDBEndpoint()
        
        let mediaRequestProvider = MediaRequestProvider(
            movieDBendpoint: movieDBEndpoint
        )
        
        let aiRequestProvider = AIRequestProvider()

        let quizRepository = QuizRepository(
            aiRequestProvider: aiRequestProvider
        )
        
        let mediaRepository = MediaRepository(
            mediaRequestProvider: mediaRequestProvider
        )
        
        let gameUtility = GameUtility(
            mediaRepository: mediaRepository,
            quizRepository: quizRepository
        )
        
        let mediaService = MediaService(
            mediaRepository: mediaRepository,
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
