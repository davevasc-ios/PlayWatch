//
//  MovieDBRepository.swift
//  PlayWatch
//
//  Created by David on 24/10/24.
//

import Foundation

protocol MovieDBProtocol {
    func makeRequest() throws -> URLRequest
}

extension MovieDBProtocol {
    func fetchMedia() async throws -> [Media] {
        let data = try await self.getData(request: self.makeRequest())
        do {
            return try JSONDecoder.convertFromSnakeCase.decode(MediaResponseDTO.self, from: data).results?.map(\.toMedia) ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
    
    private func getData(request: URLRequest) async throws-> Data {
        if let url = request.url, url.isFileURL {
            return try Data(contentsOf: url)
        } else {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == HTTP.successCode else {
                throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
            }
            return data
        }
    }
}

struct MovieDBRepository: MovieDBProtocol {
    var type: MovieDB.FetchType
    var locale: MovieDB.Locale
    var searchText: String?
    
    func makeRequest() throws -> URLRequest {
        let url = try MovieDB.Endpoint.mediaDataUrl(type: type, locale: locale, searchText: searchText)
        return HTTP.request(url: url, method: .get, fields: MovieDB.Endpoint.headerFields)
    }
}

struct MovieDBRepositoryTest: MovieDBProtocol {
    var resourceName: String
    
    func makeRequest() throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: self.resourceName, withExtension: "json") else { throw API.Error.invalidURL }
        return URLRequest(url: url)
    }
}









protocol MediaUseCaseProtocol {
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> [Media]
    func fetchMediaSearch(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String) async throws -> [Media]
}

extension MediaUseCaseProtocol {
    func fetchMediaSections(locale: MovieDB.Locale) async throws -> [MediaSection] {
        var mediaSectionsList: [MediaSection] = []
        for section in MovieDB.homeSections {
            let items = try await self.fetchMedia(for: section, locale: locale)
            mediaSectionsList.append(MediaSection(title: section.localized, items: items))
        }
        return mediaSectionsList
    }
    
    
}

struct MediaUseCase: MediaUseCaseProtocol {
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> [Media] {
        let repository = MovieDBRepository(type: type, locale: locale)
        return try await repository.fetchMedia().filterWithImage()
    }
    func fetchMediaSearch(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        let repository = MovieDBRepository(type: type, locale: locale, searchText: searchText)
        return try await repository.fetchMedia().filterWithImage()
    }
}

struct MediaUseCaseTest: MediaUseCaseProtocol {
    func fetchMedia(for type: MovieDB.FetchType, locale: MovieDB.Locale) async throws -> [Media] {
        let resourceName: String = switch type {
        case .randomMovies, .cinemaPlaying, .cinemaUpcomimg, .movieTrending, .movieNew: "Movies"
        case .tvTrending, .tvNew: "TVShows"
        case .personTrending, .personPopular: "People"
        default: "All"
        }
        let repository = MovieDBRepositoryTest(resourceName: resourceName)
        return try await repository.fetchMedia().filterWithImage()
    }
    func fetchMediaSearch(for type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String) async throws -> [Media] {
        let repository = MovieDBRepositoryTest(resourceName: "All")
        return try await repository.fetchMedia().filterWithImage()
    }
}
