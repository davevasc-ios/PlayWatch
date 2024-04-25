//
//  FetchMediaUseCase.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

//import Foundation

protocol FetchMediaProtocol {
    func fetchMedia(type: MovieDB.FetchType) async throws -> [Media]
}
struct FetchMediaUseCase: FetchMediaProtocol {
    var service: MovieDBServiceProtocol
    
    init(service: MovieDBServiceProtocol = MovieDBService()) {
        self.service = service
    }
    
    func fetchMedia(type: MovieDB.FetchType) async throws -> [Media] {
        let x = try await service.fetchMedia(type: type)
        for i in x {
            print("---Title: \(i.title ?? "")")
            print("MediaType: \(i.media)")
            print("PosterPath: \(i.posterPath ?? "")")
            print("Name: \(i.name ?? "")")
            print("originalTitle: \(i.originalTitle ?? "")")
            print("originalName: \(i.originalName ?? "")")
            print("releaseDate: \(i.releaseDate ?? "")")
            print("firstAirDate: \(i.firstAirDate ?? "")")
            print("KnownForDepartment: \(i.knownForDepartment ?? "")")
            print("mediaReleaseDate: \(String(describing: i.mediaReleaseDate))")
        }
        return x
    }
}
