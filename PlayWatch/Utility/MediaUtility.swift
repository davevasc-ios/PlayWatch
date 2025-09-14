//
//  MediaUtility.swift
//  PlayWatch
//
//  Created by David on 26/7/25.
//

import Foundation

protocol MediaUtilityProtocol: Sendable {
    func createRequest(mediaType: MediaFetchType, searchQuery: String?) throws -> URLRequest
}

extension MediaUtilityProtocol {
    
    func fetchMediaSections(sections: [MediaFetchType]) async throws -> [MediaSection] {
        try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
            for (index, section) in sections.enumerated() {
                group.addTask {
                    let mediaItems = try await self.fetchMedia(mediaType: section)
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
    
    func fetchMedia(mediaType: MediaFetchType, searchQuery: String? = nil) async throws -> [Media] {
        let request = try self.createRequest(mediaType: mediaType, searchQuery: searchQuery)
        let data = try await request.fetchData()
        return try MediaResponse.decode(from: data).mediaDTOs.mapToMedia
    }
}

struct MediaUtility: MediaUtilityProtocol {
    let mediaRequestProvider: MediaRequestProviding
        
    func createRequest(mediaType: MediaFetchType, searchQuery: String?) throws -> URLRequest {
        try self.mediaRequestProvider.createRequest(mediaType: mediaType, searchQuery: searchQuery)
    }
}
