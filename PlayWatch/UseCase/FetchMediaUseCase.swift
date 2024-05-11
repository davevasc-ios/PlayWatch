//
//  FetchMediaUseCase.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

//import Foundation

protocol FetchMediaProtocol {
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media]
}
struct FetchMediaUseCase: FetchMediaProtocol {
    var service: MovieDBServiceProtocol
    
    init(service: MovieDBServiceProtocol = MovieDBService()) {
        self.service = service
    }
    
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media] {
        return try await service.fetchMedia(type: type, locale: locale, searchText: searchText)
    }
}
