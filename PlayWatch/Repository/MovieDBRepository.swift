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
        return try MediaResponse.decode(from: data).mediaDTOs.mapToMedia
    }
}

struct MovieDBRepository: MovieDBRepositoryProtocol {
    let endpoint: EndpointProtocol
    
    init(endpoint: EndpointProtocol = MovieDBEndpoint()) {
        self.endpoint = endpoint
    }
    
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        try self.endpoint.createRequest(config: config)
    }
}
