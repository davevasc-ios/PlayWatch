//
//  FetchMediaUseCase.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

protocol FetchMediaProtocol: Sendable {
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media]
}
struct FetchMediaUseCase: FetchMediaProtocol {
    private let service: MovieDBServiceProtocol = MovieDBService()
    
    internal func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media] {
        return try await service.fetchMedia(type: type, locale: locale, searchText: searchText)
    }
}
