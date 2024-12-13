//
//  MovieDBRepository.swift
//  PlayWatch
//
//  Created by David on 24/10/24.
//

import Foundation

protocol MovieDBRepositoryProtocol: Sendable {
    var repositoryMode: RepositoryMode { get }
}

extension MovieDBRepositoryProtocol {
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String? = nil) async throws -> [Media] {
        let request = try MovieDB.createRequest(mode: repositoryMode, type: type, locale: locale, searchText: searchText)
        let data = try await request.fetchData()
        do {
            return try JSONDecoder.convertFromSnakeCase.decode(MediaResponseDTO.self, from: data).results?.map(\.toMedia) ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}

enum MovieDBRepository: MovieDBRepositoryProtocol {
    case live, test
    
    var repositoryMode: RepositoryMode {
        self == .live ? .live : .test
    }
}
