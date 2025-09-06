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
    func fetchMedia(mediaType: MediaFetchType, searchQuery: String? = nil) async throws -> [Media] {
        let request = try self.createRequest(mediaType: mediaType, searchQuery: searchQuery)
        let data = try await request.fetchData()
        return try MediaResponse.decode(from: data).mediaDTOs.mapToMedia
    }
    
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
}

struct MediaUtility: MediaUtilityProtocol {
    let endpoint: MovieDBEndpointProtocol
        
    func createRequest(mediaType: MediaFetchType, searchQuery: String?) throws -> URLRequest {
        try self.endpoint.createRequest(mediaType: mediaType, searchQuery: searchQuery)
    }
    

    
}

struct MediaUtilityPreview: MediaUtilityProtocol {
    
    func createRequest(mediaType: MediaFetchType, searchQuery: String?) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: mediaType.testResource, withExtension: PreviewConstants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
