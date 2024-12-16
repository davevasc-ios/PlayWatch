//
//  URLExtension.swift
//  PlayWatch
//
//  Created by David on 15/12/24.
//

import Foundation

extension URL {
    func toData() throws -> Data {
        do {
            return try Data(contentsOf: self)
        }
        catch {
            throw API.Error.invalidURL
        }
    }
}
