//
//  MediaUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

protocol MediaUseCaseProtocol: Sendable {
    
    var mediaRepository: MovieDBRepositoryProtocol { get }
    var storageUtility: StorageUtility { get }
}

extension MediaUseCaseProtocol {
            
    func fetchMediaSections() async throws -> [MediaSection] {
        let mediaLocale = try await self.storageUtility.loadMediaLocale()
        return try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
            for (index, section) in Constants.homeSections.enumerated() {
                group.addTask {
                    let config = MediaRequestConfig(mediaType: section, locale: mediaLocale)
                    let mediaItems = try await self.mediaRepository.fetchMedia(config: config)
                    return (index, MediaSection(title: section.localized, items: mediaItems))
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
    }
    
    func fetchTrendingMedia() async throws -> [Media] {
        let mediaLocale = try await self.storageUtility.loadMediaLocale()
        let config = MediaRequestConfig(mediaType: .trendingAll, locale: mediaLocale)
        return try await self.mediaRepository.fetchMedia(config: config)
    }
    
    func fetchSearchMedia(searchText: String) async throws -> [Media] {
        let mediaLocale = try await self.storageUtility.loadMediaLocale()
        let config = MediaRequestConfig(mediaType: .searchAll, locale: mediaLocale, searchQuery: searchText)
        return try await self.mediaRepository.fetchMedia(config: config)
    }
}

struct MediaUseCase: MediaUseCaseProtocol {
    
    let mediaRepository: MovieDBRepositoryProtocol
    let storageUtility: StorageUtility

    init(mediaRepository: MovieDBRepositoryProtocol = MovieDBRepository(),
         storageUtility: StorageUtility) {
        self.mediaRepository = mediaRepository
        self.storageUtility = storageUtility
    }
}
