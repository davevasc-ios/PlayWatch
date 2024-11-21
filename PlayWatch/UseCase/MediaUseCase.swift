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
        var mediaSections: [MediaSection] = []
        for section in MovieDB.homeSections {
            async let media = self.repository.fetchMedia(type: section, locale: locale)
            mediaSections.append(try await MediaSection(title: section.localized, items: media))
        }
        return mediaSections
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
