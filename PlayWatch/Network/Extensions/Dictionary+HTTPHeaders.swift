//
//  Dictionary+HTTPHeaders.swift
//  PlayWatch
//
//  Created by David on 11/1/25.
//

import Foundation

extension Dictionary where Key == HTTP.Header.Field, Value == HTTP.Header.Value {
    var toHTTPHeaderFields: [String: String] {
        self.reduce(into: [:]) { result, header in
            result[header.key.rawValue] = header.value.description
        }
    }
}
