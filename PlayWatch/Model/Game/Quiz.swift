//
//  Quiz.swift
//  PlayWatch
//
//  Created by David on 16/5/24.
//

import Foundation

struct Quiz: Codable, Hashable {
    let question: String?
    let result: Bool?
}

// MARK: - Decoding
extension Quiz {
    static func decode(from data: Data) throws -> [Self] {
        do {
            return try JSONDecoder().decode([Self].self, from: data)
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}
