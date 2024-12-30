//
//  MovieDBRepository.swift
//  PlayWatch
//
//  Created by David on 24/10/24.
//

import Foundation

protocol MovieDBRepositoryProtocol: Sendable {
    func createRequest(config: MediaRequestConfig) throws -> URLRequest
}

extension MovieDBRepositoryProtocol {
    func fetchMedia(config: MediaRequestConfig) async throws -> [Media] {
        let request = try self.createRequest(config: config)
        let data = try await request.fetchData()
        return try MediaResponse.decode(from: data)
    }
}

struct MovieDBRepository: MovieDBRepositoryProtocol {
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        HTTP.request(
            url: try MovieDB.Endpoint.mediaDataUrl(type: config.mediaType, locale: config.locale, searchText: config.searchQuery),
            method: .get,
            fields: MovieDB.Endpoint.headerFields
        )
    }
}
