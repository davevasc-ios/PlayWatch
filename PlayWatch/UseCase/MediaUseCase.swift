//
//  MediaUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

protocol MediaUseCaseProtocol: Sendable {
    var mediaRepository: MovieDBRepositoryProtocol { get }
}

extension MediaUseCaseProtocol {
    func fetchMediaSections(locale: MovieDB.Locale) async throws -> [MediaSection] {
        try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
            for (index, section) in MovieDB.homeSections.enumerated() {
                group.addTask {
                    let mediaItems = try await self.mediaRepository.fetchMedia(type: section, locale: locale)
                    return (index, MediaSection(title: section.localized, items: mediaItems))
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
    }
    
    func fetchTrendingMedia(locale: MovieDB.Locale) async throws -> [Media] {
        try await self.mediaRepository.fetchMedia(type: .trendingAll, locale: locale)
    }
    
    func fetchSearchMedia(locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        try await self.mediaRepository.fetchMedia(type: .searchAll, locale: locale, searchText: searchText)
    }
}

struct MediaUseCase: MediaUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
}
