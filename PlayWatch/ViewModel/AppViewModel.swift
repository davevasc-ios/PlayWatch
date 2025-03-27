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
    
    init(homeModelLogic: HomeModelLogic = HomeModelLogic(),
         gameModelLogic: GameModelLogic = GameModelLogic(),
         settingsModelLogic: SettingsModelLogic = SettingsModelLogic()) {
        self.homeModelLogic = homeModelLogic
        self.gameModelLogic = gameModelLogic
        self.settingsModelLogic = settingsModelLogic
    }
}

extension AppViewModel {
    static var production: AppViewModel {
        
        let movieDBRepository: MovieDBRepositoryProtocol = MovieDBRepository()
        let multiAIRepository: MultiAIRepositoryProtocol = MultiAIRepository()
        let storageRepository: StorageRepositoryProtocol = StorageRepository()
        
        return AppViewModel(
            homeModelLogic: HomeModelLogic(
                mediaUseCase: MediaUseCase(
                    mediaRepository: movieDBRepository,
                    storageRepository: storageRepository)
            ),
            gameModelLogic: GameModelLogic(
                gameUseCase: GameUseCase(
                    mediaRepository: movieDBRepository,
                    gameRepository: multiAIRepository,
                    storageRepository: storageRepository
                )
            ),
            settingsModelLogic: SettingsModelLogic(
                settingsUseCase: SettingsUseCase(
                    storageRepository: storageRepository))
        )
    }
}
