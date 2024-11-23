//
//  MovieDBRepository.swift
//  PlayWatch
//
//  Created by David on 24/10/24.
//

import Foundation

protocol MovieDBRepositoryProtocol: Sendable {
    var repositoryType: RepositoryType { get }
}

extension MovieDBRepositoryProtocol {
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String? = nil) async throws -> [Media] {
        let request = try self.createRequest(type: type, locale: locale, searchText: searchText)
        let data = try await request.fetchData()
        do {
            return try JSONDecoder.convertFromSnakeCase.decode(MediaResponseDTO.self, from: data).results?.map(\.toMedia) ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
    
    private func createRequest(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String? = nil) throws -> URLRequest {
        switch self.repositoryType {
        case .live:
            HTTP.request(
                url: try MovieDB.Endpoint.mediaDataUrl(type: type, locale: locale, searchText: searchText),
                method: .get,
                fields: MovieDB.Endpoint.headerFields
            )
        case .test:
            try Bundle.main.jsonURLRequest(forResource: type.testResource)
        }
    }
}

struct MovieDBRepository: MovieDBRepositoryProtocol {
    var repositoryType: RepositoryType {
        .live
    }
}

struct MovieDBRepositoryTest: MovieDBRepositoryProtocol {
    var repositoryType: RepositoryType {
        .test
    }
}
