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
    static func decode(from data: Data,
                       using decoder: DataDecoder = JSONDecoder.withSnakeCaseStrategy) throws -> Self {
        do {
           return try decoder.decode(Self.self, from: data)
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}

// MARK: - Extract Response String
extension MediaResponse {
    var mediaDTOs: [MediaDTO] {
        self.results.orEmpty
    }
}
