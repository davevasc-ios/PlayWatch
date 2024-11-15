//
//  MediaUseCase.swift
//  PlayWatch
//
//  Created by David on 3/11/24.
//

protocol MediaUseCaseProtocol {
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> [Media]
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String) async throws -> [Media]
}

extension MediaUseCaseProtocol {
    func fetchMediaSections(locale: MovieDB.Locale) async throws -> [MediaSection] {
        var mediaSections: [MediaSection] = []
        for section in MovieDB.homeSections {
            let items = try await self.fetchMedia(for: section, locale: locale)
            mediaSections.append(MediaSection(title: section.localized, items: items))
        }
        return mediaSections
    }
}

//extension MediaUseCaseProtocol {
//    static func fetchMediaSection(type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> MediaSection {
//        let repository: MovieDBRepositoryProtocol = MovieDBRepository(type: type, locale: locale)
//        let items = try await repository.fetchMedia().filterWithImage()
//        return MediaSection(title: type.localized, items: items)
//    }
//
//    func fetchMediaSections(locale: MovieDB.Locale) async throws -> [MediaSection] {
//        var mediaSections: [MediaSection] = []
//        for section in MovieDB.homeSections {
//            async let media = MediaUseCase.fetchMediaSection(type: section, locale: locale)
//            mediaSections.append(try await media)
//        }
//        return mediaSections
//    }
//}

struct MediaUseCase: MediaUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> [Media] {
        try await mediaRepository.fetchMedia(resourceName: "", type: type, locale: locale, searchText: nil).filterWithImage()
    }
    
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        try await mediaRepository.fetchMedia(resourceName: "", type: type, locale: locale, searchText: searchText).filterWithImage()
    }
}

struct MediaUseCaseTest: MediaUseCaseProtocol {
    let mediaRepository: MovieDBRepositoryProtocol
    
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> [Media] {
        let resourceName: String = switch type {
        case .randomMovies, .cinemaPlaying, .cinemaUpcomimg, .movieTrending, .movieNew: Constants.Resource.Name.movies
        case .tvTrending, .tvNew: Constants.Resource.Name.tvShows
        case .personTrending, .personPopular: Constants.Resource.Name.people
        default: Constants.Resource.Name.all
        }
        return try await mediaRepository.fetchMedia(resourceName: resourceName, type: type, locale: locale, searchText: nil).filterWithImage()
    }
    
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        return try await mediaRepository.fetchMedia(resourceName: Constants.Resource.Name.all, type: type, locale: locale, searchText: searchText).filterWithImage()
    }
}
