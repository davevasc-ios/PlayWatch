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
    var settingsModelLogic: SettingsModelLogic
    
    init(homeModelLogic: HomeModelLogic = HomeModelLogic(),
         gameModelLogic: GameModelLogic = GameModelLogic(),
         settingsModelLogic: SettingsModelLogic = SettingsModelLogic()) {
        self.homeModelLogic = homeModelLogic
        self.gameModelLogic = gameModelLogic
        self.settingsModelLogic = settingsModelLogic
    }
}
