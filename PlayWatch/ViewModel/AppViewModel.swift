//
//  AppViewModel.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

@Observable
final class AppViewModel {
    
    let homeModelLogic: HomeModelLogic
    let gameModelLogic: GameModelLogic
    let appManager: AppManager
    
    init(homeModelLogic: HomeModelLogic = HomeModelLogic(),
         gameModelLogic: GameModelLogic = GameModelLogic(),
         appManager: AppManager = AppManager()) {
        self.homeModelLogic = homeModelLogic
        self.gameModelLogic = gameModelLogic
        self.appManager = appManager
    }
}
