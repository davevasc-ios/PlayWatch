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
    static func decode(from data: Data, using decoder: DataDecoder = JSONDecoder()) throws -> [Self] {
        do {
            return try decoder.decode([Self].self, from: data)
        } catch let decodingError {
            throw API.Error.invalidData(detail: decodingError.localizedDescription)
        }
    }
}
