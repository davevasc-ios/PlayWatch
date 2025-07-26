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
    
    enum InitializationState {
        case initial, loading, loaded, error
    }
    private(set) var initializationState: InitializationState = .initial
    
    
    // MARK: - Provisional
    var sectionTitle: String = ""
    
    // MARK: - Public Properties
    var theme: SettingsView.Theme = .light
    var language: AppLanguage = .system
    var region: AppRegion = AppRegion.system
    var server: AIServer = AIServer.openAI
    
    var errorMessage: String?
    
    var appLocale: Locale {
        Locale(identifier: "\(self.language.languageCode)-\(self.region.regionCode)")
    }
    
    // MARK: - Private Properties
    @ObservationIgnored private let storageUtility: StorageUtility

    // MARK: - Initialization
    init(
         storageUtility: StorageUtility
    ) {
        self.storageUtility = storageUtility
    }
    
    // MARK: - Event Handling
    enum Event {
        case initialize
        case viewAppear
        case updateTheme(SettingsView.Theme)
        case updateLanguage(AppLanguage)
        case updateRegion(AppRegion)
        case updateServer(AIServer)
    }
    
    func on(_ event: Event) {
        switch event {
        case .initialize:
            self.loadInitialSettings()
        case .viewAppear:
            self.loadAllSettings()
        case .updateTheme(let theme):
            self.updateTheme(to: theme)
        case .updateLanguage(let language):
            self.updateLanguage(to: language)
        case .updateRegion(let region):
            self.updateRegion(to: region)
        case .updateServer(let server):
            self.updateServer(to: server)
        }
    }
    
    @MainActor
       func loadInitialSettings() {
           // Solo carga si no lo ha hecho ya.
           guard initializationState != .loaded else { return }
           
           self.initializationState = .loading
           
           Task {
               do {
                   let settings = try await storageUtility.loadAll()
                   self.theme = settings.theme
                   self.language = settings.language
                   self.region = settings.region
                   self.initializationState = .loaded // ¡Cargado con éxito!
               } catch {
                   self.errorMessage = error.localizedDescription
                   self.initializationState = .error // Error al cargar
               }
           }
       }
    
    // MARK: - Carga inicial
    @MainActor
    func loadAllSettings() {
        Task {
            do {
                let settings = try await storageUtility.loadAll()
                theme = settings.theme
                language = settings.language
                region = settings.region
                server = settings.server
                self.updateSectionTitle()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // MARK: - Actualizaciones granulares
    @MainActor
    func updateTheme(to new: SettingsView.Theme) {
        theme = new
        Task {
            do {
                try await self.storageUtility.saveTheme(new)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func updateLanguage(to new: AppLanguage) {
        language = new
        Task {
            do {
                try await self.storageUtility.saveLanguage(new)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func updateRegion(to new: AppRegion) {
        region = new
        Task {
            do {
                try await self.storageUtility.saveRegion(new)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    @MainActor
    func updateServer(to new: AIServer) {
        server = new
        Task {
            do {
                try await self.storageUtility.saveServer(new)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func updateSectionTitle() {
        var lang = Tab.settings.localized
        lang.locale = self.appLocale
        self.sectionTitle = String(localized: lang)
    }
}
