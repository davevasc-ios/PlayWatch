//
//  StorageRepository.swift
//  PlayWatch
//
//  Created by David on 23/2/25.
//

import Foundation

struct SettingsDTO: Codable {
    var theme: String
    var language: String
    var region: String
    var server: String
}

// MARK: - DTO to Domain Mapping
extension SettingsDTO {
    var toSettings: Settings {
        Settings(theme: SettingsView.Theme(rawValue: self.theme) ?? .light,
                 language: AppLanguage(rawValue: self.language) ?? .system,
                 region: AppRegion(rawValue: self.region) ?? .system,
                 server: AIServer(rawValue: self.server) ?? .openAI)
    }
}

struct Settings {
    var theme: SettingsView.Theme
    var language: AppLanguage
    var region: AppRegion
    var server: AIServer
    
    static let empty = Settings(theme: .light,
                                language: .system,
                                region: .system,
                                server: .openAI)
}

extension Settings {
    var mediaLocale: MediaLocale {
        MediaLocale(name: self.language.name,
                    code: self.language.languageCode,
                    region: self.region.regionCode)
    }
}

extension Settings {
    var toDTO: SettingsDTO {
        .init(theme: self.theme.rawValue,
              language: self.language.rawValue,
              region: self.region.rawValue,
              server: self.server.rawValue)
    }
}

protocol StorageRepositoryProtocol: Sendable {
    func loadSettings() async throws -> Settings
    func saveSettings(_ settings: Settings) async throws
}

actor StorageRepository: StorageRepositoryProtocol {
    
    private let fileURL: URL
    private var cachedSettings: Settings?
    
    init(fileURL: URL = {
        let fileManager = FileManager.default
        let documents = try! fileManager.url(for: .documentDirectory,
                                             in: .userDomainMask,
                                             appropriateFor: nil,
                                             create: true)
        return documents.appendingPathComponent("settings.json")
    }()) {
        self.fileURL = fileURL
    }
    
    func loadSettings() async throws -> Settings {
        if let cached = self.cachedSettings {
            return cached
        }
        let data = try Data(contentsOf: self.fileURL)
        let decoder = JSONDecoder()
        let settings = try decoder.decode(SettingsDTO.self, from: data).toSettings
        self.cachedSettings = settings
        return settings
    }
    
    func saveSettings(_ settings: Settings) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(settings.toDTO)
        try data.write(to: fileURL)
        self.cachedSettings = settings
    }
}
