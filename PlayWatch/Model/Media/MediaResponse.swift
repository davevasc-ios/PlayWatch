//
//  MediaResponse.swift
//  PlayWatch
//
//  Created by David on 17/12/24.
//

import Foundation

struct MediaResponse: Codable {
    let results: [MediaDTO]?
}

// MARK: - Decoding
extension MediaResponse {
    static func decode(
        from data: Data,
        using decoder: DataDecoder = JSONDecoder.withSnakeCaseStrategy
    ) throws -> [Media] {
        do {
            let decodedResponse = try decoder.decode(Self.self, from: data)
            return decodedResponse.mediaDTOs.mapToMedia
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}

// MARK: - Extract Response String
extension MediaResponse {
    var mediaDTOs: [MediaDTO] {
        self.results.orEmpty
    }
}
