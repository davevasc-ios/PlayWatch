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

struct MediaUseCase: MediaUseCaseProtocol {
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> [Media] {
        let repository: MovieDBRepositoryProtocol = MovieDBRepository(type: type, locale: locale)
        return try await repository.fetchMedia().filterWithImage()
    }
    
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        let repository: MovieDBRepositoryProtocol = MovieDBRepository(type: type, locale: locale, searchText: searchText)
        return try await repository.fetchMedia().filterWithImage()
    }
}

struct MediaUseCaseTest: MediaUseCaseProtocol {
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> [Media] {
        let resourceName: String = switch type {
        case .randomMovies, .cinemaPlaying, .cinemaUpcomimg, .movieTrending, .movieNew: Constants.Resource.Name.movies
        case .tvTrending, .tvNew: Constants.Resource.Name.tvShows
        case .personTrending, .personPopular: Constants.Resource.Name.people
        default: Constants.Resource.Name.all
        }
        let repository: MovieDBRepositoryProtocol = MovieDBRepositoryTest(resourceName: resourceName)
        return try await repository.fetchMedia().filterWithImage()
    }
    
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        let repository: MovieDBRepositoryProtocol = MovieDBRepositoryTest(resourceName: Constants.Resource.Name.all)
        return try await repository.fetchMedia().filterWithImage()
    }
}
