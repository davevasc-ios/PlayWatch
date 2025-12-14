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
        let mediaSections = try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
            for (index, section) in sections.enumerated() {
                group.addTask {
                    let mediaItems = try await self.fetchMedia(for: section, with: locale)
                    return await (index, MediaSection(type: section.type, items: mediaItems))
                }
            }
            var collected = [(Int, MediaSection)]()
            for try await result in group {
                collected.append(result)
            }
            return collected.sorted(by: { $0.0 < $1.0 }).map { $0.1 }
        }
        let newMediaSection = MediaSection(type: .hero, items: mediaSections.first?.items ?? [])
        return [newMediaSection] + mediaSections
    }
    
    func fetchMedia(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String? = nil) async throws -> [Media] {
        let request = try self.createRequest(for: type, with: locale, searchQuery: searchQuery)
        let data = try await request.fetchData()
        return try MediaResponse.decode(from: data)
    }
}

struct MediaRepository: MediaRopositoryProtocol {
    let mediaRequestProvider: MediaRequestProviding
        
    func createRequest(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) throws -> URLRequest {
        try self.mediaRequestProvider.createRequest(for: type, with: locale, searchQuery: searchQuery)
    }
}
