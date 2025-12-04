//
//  JSONDecoder+SnakeCase.swift
//  PlayWatch
//
//  Created by David on 25/10/24.
//

import Foundation

protocol DataDecoder: Sendable {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: DataDecoder {
    static let withSnakeCaseStrategy: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
