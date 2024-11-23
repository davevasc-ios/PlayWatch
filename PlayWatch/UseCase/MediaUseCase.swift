//
//  MediaUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

protocol MediaUseCaseProtocol: Sendable {
    var repository: MovieDBRepositoryProtocol { get }
}

extension MediaUseCaseProtocol {
    func fetchMediaSections(locale: MovieDB.Locale) async throws -> [MediaSection] {
        try await withThrowingTaskGroup(of: MediaSection.self) { group in
            for section in MovieDB.homeSections {
                group.addTask {
                    let mediaItems = try await self.repository.fetchMedia(type: section, locale: locale)
                    return MediaSection(title: section.localized, items: mediaItems)
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }
    }
    
    func fetchTrendingMedia(locale: MovieDB.Locale) async throws -> [Media] {
        try await self.repository.fetchMedia(type: .trendingAll, locale: locale)
    }
    
    func fetchSearchMedia(locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        try await self.repository.fetchMedia(type: .searchAll, locale: locale, searchText: searchText)
    }
}

struct MediaUseCase: MediaUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    
    var repository: MovieDBRepositoryProtocol {
        self.mediaRepository
    }
}
