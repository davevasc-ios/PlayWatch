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
    static func decode(from data: Data) throws -> [Media] {
        do {
            let response = try JSONDecoder.convertFromSnakeCase.decode(Self.self, from: data)
            return (response.results?.map(\.toMedia)).orEmpty
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}
