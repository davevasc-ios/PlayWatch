//
//  MovieDBUtility.swift
//  PlayWatch
//
//  Created by David on 26/7/25.
//

import Foundation

protocol MovieDBUtilityProtocol {
    func createRequest(config: MediaRequestConfig) throws -> URLRequest
    func fetchSections(sections: [MediaFetchType], mediaLocale: MediaLocale) async throws -> [MediaSection]
}



extension MovieDBUtilityProtocol {
    func fetchMedia(config: MediaRequestConfig) async throws -> [Media] {
        let request = try self.createRequest(config: config)
        let data = try await request.fetchData()
        return try MediaResponse.decode(from: data).mediaDTOs.mapToMedia
    }
    
    
    
}

struct MovieDBUtility: MovieDBUtilityProtocol {
    let endpoint: MediaEndpointProtocol
    
    init(endpoint: MediaEndpointProtocol) {
        self.endpoint = endpoint
    }
    
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        try self.endpoint.createRequest(config: config)
    }
    
    func fetchSections(sections: [MediaFetchType], mediaLocale: MediaLocale) async throws -> [MediaSection] {
        try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
            for (index, section) in sections.enumerated() {
                group.addTask {
                    let config = MediaRequestConfig(mediaType: section, locale: mediaLocale)
                    let mediaItems = try await self.fetchMedia(config: config)
                    return (index, MediaSection(title: section.localized, items: mediaItems))
                }
            }
            var collected = [(Int, MediaSection)]()
            for try await result in group {
                collected.append(result)
            }
            return collected.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
        }
    }
    
//    func fetchSections(sections: [MediaFetchType], mediaLocale: MediaLocale) async throws -> [MediaSection] {
//        var mediaSections = [(Int, MediaSection)]()
//        for (index, section) in sections.enumerated() {
//            let config = MediaRequestConfig(mediaType: section, locale: mediaLocale)
//            let mediaItems = try await self.fetchMedia(config: config)
//            mediaSections.append((index, MediaSection(title: section.localized, items: mediaItems)))
//        }
//        return mediaSections.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
//    }
    
}
