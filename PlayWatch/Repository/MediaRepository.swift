//
//  MediaRepository.swift
//  PlayWatch
//
//  Created by David on 26/7/25.
//

import Foundation

protocol MediaRopositoryProtocol: Sendable {
    func createRequest(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) throws -> URLRequest
}

extension MediaRopositoryProtocol {
    
    func fetchMediaSections(for sections: [MediaFetchType], with locale: MediaLocale) async throws -> [MediaSection] {
        try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
            for (index, section) in sections.enumerated() {
                group.addTask {
                    let mediaItems = try await self.fetchMedia(for: section, with: locale)
                    return await (index, MediaSection(title: section.localized, items: mediaItems))
                }
            }
            var collected = [(Int, MediaSection)]()
            for try await result in group {
                collected.append(result)
            }
            return collected.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
        }
    }
    
    func fetchMedia(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String? = nil) async throws -> [Media] {
        let request = try self.createRequest(for: type, with: locale, searchQuery: searchQuery)
        let data = try await request.fetchData()
        return try MediaResponse.decode(from: data).mediaDTOs.mapToMedia
    }
}

struct MediaRepository: MediaRopositoryProtocol {
    let mediaRequestProvider: MediaRequestProviding
        
    func createRequest(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) throws -> URLRequest {
        try self.mediaRequestProvider.createRequest(for: type, with: locale, searchQuery: searchQuery)
    }
}
