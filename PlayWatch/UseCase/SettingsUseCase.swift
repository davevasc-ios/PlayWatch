//
//  SettingsUseCase.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation

protocol SettingsUseCaseProtocol: Sendable {
    
    var storageRepository: StorageRepositoryProtocol { get }
}

extension SettingsUseCaseProtocol {
        
//    func getTheme() async throws -> SettingsView.Theme {
//        let settings = try await self.getSettings()
//        return settings.theme
//    }
//    func setTheme(theme: SettingsView.Theme) async throws {
//        var settings = try await self.getSettings()
//        settings.theme = theme
//        try await self.setSettings(settings)
//    }
    
    func getSettings() async throws -> Settings {
        try await storageRepository.loadSettings()
    }
    
    func setSettings(_ settings: Settings) async throws {
        try await storageRepository.saveSettings(settings)
    }
    
}

struct SettingsUseCase: SettingsUseCaseProtocol {
    let storageRepository: StorageRepositoryProtocol
    
    init(storageRepository: StorageRepositoryProtocol = StorageRepository()) {
        self.storageRepository = storageRepository
    }
}
