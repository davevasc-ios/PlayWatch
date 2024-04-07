//
//  HTTP.swift
//  PlayWatch
//
//  Created by David on 7/4/24.
//

import Foundation

struct HTTP {
    struct Method {
        static let get = "GET"
        static let post = "POST"
    }
    struct Code {
        static let success = 200
    }
    struct Header {
        struct Field {
            static let authorization = "Authorization"
            static let accept = "accept"
            static let contentType = "Content-Type"
        }
        struct Value {
            static let applicationJson = "application/json"
            static func bearer(key: API.Key) -> String {
                return "Bearer \(key)"
            }
        }
    }
}
