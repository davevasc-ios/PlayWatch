//
//  MediaRepository.swift
//  PlayWatch
//
//  Created by David on 26/7/25.
//

import Foundation

protocol MediaRepositoryProtocol: Sendable {
    func fetchMedia(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) async throws -> [Media]
}

extension MediaRepositoryProtocol {

    func fetchMediaSections(for sections: [MediaFetchType], with locale: MediaLocale) async throws -> [MediaSection] {
        let mediaSections = try await withThrowingTaskGroup(of: (Int, MediaSection).self) { group in
            for (index, section) in sections.enumerated() {
                group.addTask {
                    let mediaItems = try await self.fetchMedia(for: section, with: locale, searchQuery: nil)
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
}

struct MediaRepository: MediaRepositoryProtocol {
    let mediaRequestProvider: MediaRequestProviding
       
    func fetchMedia(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) async throws -> [Media] {
        let request = try self.createRequest(for: type, with: locale, searchQuery: searchQuery)
        let data = try await request.fetchData()
        return try MediaResponse.decode(from: data)
    }
    
    private func createRequest(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) throws -> URLRequest {
        try self.mediaRequestProvider.createRequest(for: type, with: locale, searchQuery: searchQuery)
    }
}
