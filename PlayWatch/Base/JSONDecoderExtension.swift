//
//  JSONDecoderExtension.swift
//  PlayWatch
//
//  Created by David on 25/10/24.
//

import Foundation

extension JSONDecoder {
    static var convertFromSnakeCase: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
