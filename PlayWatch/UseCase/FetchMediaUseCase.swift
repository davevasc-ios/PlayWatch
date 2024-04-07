//
//  FetchMediaUseCase.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

protocol FetchMediaProtocol {
    func fetchMedia() async throws -> String
}
struct FetchMediaUseCase: FetchMediaProtocol {
    var service: MovieDBServiceProtocol
    
    init(service: MovieDBServiceProtocol = MovieDBService()) {
        self.service = service
    }
    
    func fetchMedia() async throws -> String {
        let query = MovieDB.QueryData(mode: .search, media: .tv, period: .week, provider: .netflix, query: "brad")
        let x = try await service.fetchMedia(query: query)
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
        return "ok"
    }
}
