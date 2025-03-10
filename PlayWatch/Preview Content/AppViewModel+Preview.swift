//
//  AppViewModel+Preview.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation

extension AppViewModel {
    static var preview: AppViewModel {
        AppViewModel(
            homeModelLogic: HomeModelLogic(
                mediaUseCase: MediaUseCase(
                    mediaRepository: MovieDBRepositoryPreview())
            ),
            gameModelLogic: GameModelLogic(
                gameUseCase: GameUseCase(
                    mediaRepository: MovieDBRepositoryPreview(),
                    gameRepository: MultiAIRepositoryPreview()
                )
            )
        )
    }
}

