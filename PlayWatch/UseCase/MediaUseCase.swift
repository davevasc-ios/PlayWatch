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
    func fetchMediaSections(locale: MediaLocale) async throws -> [MediaSection] {
        try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
            for (index, section) in Constants.homeSections.enumerated() {
                group.addTask {
                    let config = MediaRequestConfig(mediaType: section, locale: locale)
                    let mediaItems = try await self.mediaRepository.fetchMedia(config: config)
                    return (index, MediaSection(title: section.localized, items: mediaItems))
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
    }
    
    func fetchTrendingMedia(locale: MediaLocale) async throws -> [Media] {
        let config = MediaRequestConfig(mediaType: .trendingAll, locale: locale)
        return try await self.mediaRepository.fetchMedia(config: config)
    }
    
    func fetchSearchMedia(locale: MediaLocale, searchText: String) async throws -> [Media] {
        let config = MediaRequestConfig(mediaType: .searchAll, locale: locale, searchQuery: searchText)
        return try await self.mediaRepository.fetchMedia(config: config)
    }
}

struct MediaUseCase: MediaUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    
    init(mediaRepository: MovieDBRepositoryProtocol = MovieDBRepository()) {
        self.mediaRepository = mediaRepository
    }
}
