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
    static func production(storageUtility: StorageUtility) -> AppViewModel {
        
        let movieDBRepository: MovieDBRepositoryProtocol = MovieDBRepository()
        let multiAIRepository: MultiAIRepositoryProtocol = MultiAIRepository()
        
        let movieDBEndpoint: MediaEndpointProtocol = MovieDBEndpoint()
        
        let movieDBUtility: MovieDBUtilityProtocol = MovieDBUtility(endpoint: movieDBEndpoint)
        
        
        let homeLogic = HomeModelLogic(
            mediaUseCase: MediaUseCase(
                mediaRepository: movieDBRepository,
                storageUtility: storageUtility),
            movieDBUtility: movieDBUtility,
            storageUtility: storageUtility
        )
        
        let gameLogic = GameModelLogic(
            gameUseCase: GameUseCase(
                mediaRepository: movieDBRepository,
                gameRepository: multiAIRepository,
                storageUtility: storageUtility
            )
        )
        
        let settingsLogic = SettingsModelLogic(
            storageUtility: storageUtility
        )
                
        return AppViewModel(
            homeModelLogic: homeLogic,
            gameModelLogic: gameLogic,
            settingsModelLogic: settingsLogic
        )
    }
}
