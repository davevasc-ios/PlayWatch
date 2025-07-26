//
//  AppViewModel+Preview.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation
import SwiftData

extension AppViewModel {
    
    @MainActor
    static var preview: AppViewModel {
                
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: SettingsModel.self, configurations: config)
        // Nota: Usamos try! aquí porque si esto falla, la preview no puede funcionar
        // y queremos que crashee para saberlo inmediatamente.

        // --- 2. Construir la Cadena de Dependencias de PREVIEW ---
        let movieDBEndpoint: MediaEndpointProtocol = MovieDBEndpoint()
        let movieDBUtility: MovieDBUtilityProtocol = MovieDBUtility(endpoint: movieDBEndpoint)

        let previewStorageUtility = StorageUtility(context: container.mainContext)
        
        let homeLogic = HomeModelLogic(
            mediaUseCase: MediaUseCase(
                mediaRepository: MovieDBRepositoryPreview(),
                storageUtility: previewStorageUtility
            ), movieDBUtility: movieDBUtility, storageUtility: previewStorageUtility
        )
        
        let gameLogic = GameModelLogic(
            gameUseCase: GameUseCase(
                mediaRepository: MovieDBRepositoryPreview(),
                gameRepository: MultiAIRepositoryPreview(),
                storageUtility: previewStorageUtility
            )
        )
        
        let settingsLogic = SettingsModelLogic(
            storageUtility: previewStorageUtility
        )
        
        return AppViewModel(
            homeModelLogic: homeLogic,
            gameModelLogic: gameLogic,
            settingsModelLogic: settingsLogic
        )
    }
}
