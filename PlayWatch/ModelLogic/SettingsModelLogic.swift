//
//  SettingsModelLogic.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation
import Observation

@Observable
final class SettingsModelLogic: EventHandler {
    
    // MARK: - Provisional
    var sectionTitle: String = ""
    
    // MARK: - Public Properties
    var theme: SettingsView.Theme = .light
    var language: AppLanguage = .system
    var region: AppRegion = AppRegion.system
    var server: AIServer = AIServer.openAI
    
    var appLocale: Locale {
        Locale(identifier: "\(self.language.languageCode)-\(self.region.regionCode)")
    }
    
    // MARK: - Private Properties
    @ObservationIgnored private let settingsUseCase: SettingsUseCaseProtocol

    // MARK: - Initialization
    init(settingsUseCase: SettingsUseCaseProtocol = SettingsUseCase()) {
        self.settingsUseCase = settingsUseCase
    }
    
    // MARK: - Event Handling
    enum Event {
        case viewAppear
        case updateSettings
    }
    
    func on(_ event: Event) {
        switch event {
        case .viewAppear:
            self.getSettings()
        case .updateSettings:
            self.setSettings()
        }
    }
    
    // MARK: - Private Methods
    @MainActor
    private func getSettings() {
        Task {
            if let settings = try? await self.settingsUseCase.getSettings() {
                self.theme = settings.theme
                self.language = settings.language
                self.region = settings.region
                self.server = settings.server
            }
            self.updateSectionTitle()
        }
    }
    
    @MainActor
    private func setSettings() {
        Task {
            let settings = Settings(theme: self.theme, language: self.language, region: self.region, server: self.server)
            try? await self.settingsUseCase.setSettings(settings)
            self.updateSectionTitle()
        }
    }
    
    private func updateSectionTitle() {
        var lang = Tab.settings.localized
        lang.locale = self.appLocale
        self.sectionTitle = String(localized: lang)
    }
}
