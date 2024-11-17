//
//  MediaUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

protocol MediaUseCaseProtocol: Sendable {
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media]
}

extension MediaUseCaseProtocol {
    func fetchMediaSections(locale: MovieDB.Locale) async throws -> [MediaSection] {
        var mediaSections: [MediaSection] = []
        for section in MovieDB.homeSections {
            async let media = self.fetchMedia(for: section, locale: locale, searchText: nil)
            mediaSections.append(try await MediaSection(title: section.localized, items: media))
        }
        return mediaSections
    }
    
    func fetchTrendingMedia(locale: MovieDB.Locale) async throws -> [Media] {
        try await self.fetchMedia(for: .trendingAll, locale: locale, searchText: nil)
    }
    
    func fetchSearchMedia(locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        try await self.fetchMedia(for: .searchAll, locale: locale, searchText: searchText)
    }
}

struct MediaUseCase: MediaUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    
    internal func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media] {
        try await mediaRepository.fetchMediaByType(type: type, locale: locale, searchText: searchText).filterWithImage()
    }
}

struct MediaUseCaseTest: MediaUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    
    internal func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media] {
        let resourceName: String = switch type {
        case .randomMovies, .cinemaPlaying, .cinemaUpcomimg, .movieTrending, .movieNew: Constants.Resource.Name.movies
        case .tvTrending, .tvNew: Constants.Resource.Name.tvShows
        case .personTrending, .personPopular: Constants.Resource.Name.people
        default: Constants.Resource.Name.all
        }
        return try await mediaRepository.fetchMediaByTest(resourceName: resourceName).filterWithImage()
    }
}
