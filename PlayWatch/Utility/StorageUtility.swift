//
//  StorageUtility.swift
//  PlayWatch
//
//  Created by David on 25/7/25.
//

import Foundation
import SwiftData

struct Settings {
    var theme: SettingsView.Theme
    var language: AppLanguage
    var region: AppRegion
    var server: AIServer
    
    static let empty = Settings(theme: .light,
                                language: .system,
                                region: .system,
                                server: .openAI)
    
    var mediaLocale: MediaLocale {
        MediaLocale(name: self.language.name,
                    code: self.language.languageCode,
                    region: self.region.regionCode)
    }
}

@Model
final class SettingsModel {
    @Attribute(.unique) var id: UUID
    var theme: SettingsView.Theme
    var language: AppLanguage
    var region: AppRegion
    var server: AIServer

    init(
        id: UUID = UUID(),
        theme: SettingsView.Theme = .light,
        language: AppLanguage = .system,
        region: AppRegion = .system,
        server: AIServer = .openAI
    ) {
        self.id = id
        self.theme = theme
        self.language = language
        self.region = region
        self.server = server
    }
}

actor StorageUtility {
    private let context: ModelContext
    private var cachedModel: SettingsModel?

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Fetch o creación (singleton)
    private func fetchModel() throws -> SettingsModel {
        if let model = cachedModel {
            return model
        }

        // 2. Si no, lo buscamos en la base de datos.
        let request = FetchDescriptor<SettingsModel>()
        if let model = try context.fetch(request).first {
            cachedModel = model // Guardamos en caché para la próxima vez.
            return model
        }

        // 3. Si no existe en ningún lado, lo creamos.
        let newModel = SettingsModel()
        context.insert(newModel)
        
        // ¡CORRECCIÓN CLAVE! Guardamos inmediatamente para asegurar la persistencia.
        try context.save()
        
        cachedModel = newModel // Lo guardamos en caché.
        return newModel
    }
        
    // MARK: - Carga completa
    func loadAll() async throws -> Settings {
        let model = try fetchModel()
        return Settings(
            theme: model.theme,
            language: model.language,
            region: model.region,
            server: model.server
        )
    }
    
    // MARK: - Carga de media locale
    func loadMediaLocale() async throws -> MediaLocale {
        let settings = try await self.loadAll()
        return settings.mediaLocale
    }

    // MARK: - Operaciones granulares
    func loadTheme() async throws -> SettingsView.Theme {
        try fetchModel().theme
    }

    func saveTheme(_ theme: SettingsView.Theme) async throws {
        let model = try fetchModel()
        model.theme = theme
        try context.save()
    }

    func loadLanguage() async throws -> AppLanguage {
        try fetchModel().language
    }

    func saveLanguage(_ language: AppLanguage) async throws {
        let model = try fetchModel()
        model.language = language
        try context.save()
    }

    func loadRegion() async throws -> AppRegion {
        try fetchModel().region
    }

    func saveRegion(_ region: AppRegion) async throws {
        let model = try fetchModel()
        model.region = region
        try context.save()
    }

    func loadServer() async throws -> AIServer {
        try fetchModel().server
    }

    func saveServer(_ server: AIServer) async throws {
        let model = try fetchModel()
        model.server = server
        try context.save()
    }
}

