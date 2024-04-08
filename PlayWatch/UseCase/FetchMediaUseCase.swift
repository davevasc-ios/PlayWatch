//
//  FetchMediaUseCase.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

protocol FetchMediaProtocol {
    func fetchMedia(section: MovieDB.QueryType) async throws -> [Media]
}
struct FetchMediaUseCase: FetchMediaProtocol {
    var service: MovieDBServiceProtocol
    
    init(service: MovieDBServiceProtocol = MovieDBService()) {
        self.service = service
    }
    
    func fetchMedia(section: MovieDB.QueryType) async throws -> [Media] {
//        let query = MovieDB.QueryData(mode: .search, media: .tv, period: .week, provider: .netflix, query: "brad")
        let x = try await service.fetchMedia(section: section)
        for i in x {
            print("---Title: \(i.title ?? "")")
            print("MediaType: \(i.mediaType ?? .movie)")
            print("PosterPath: \(i.posterPath ?? "")")
            print("Name: \(i.name ?? "")")
            print("originalTitle: \(i.originalTitle ?? "")")
            print("originalName: \(i.originalName ?? "")")
            print("releaseDate: \(i.releaseDate ?? "")")
            print("firstAirDate: \(i.firstAirDate ?? "")")
            print("KnownForDepartment: \(i.KnownForDepartment ?? "")")
        }
        return x
//        return "ok"
    }
}
