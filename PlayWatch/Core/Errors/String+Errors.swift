//
//  String+Errors.swift
//  PlayWatch
//
//  Created by David on 16/12/24.
//

import Foundation

// MARK: - String Errors
extension String {
    enum Error: LocalizedError {
        case invalidUTF8Conversion(string: String)
        
        var errorDescription: String? {
            switch self {
            case .invalidUTF8Conversion(let string):
                return "Failed to convert string '\(string)' to UTF8 data."
            }
        }
    }
}
