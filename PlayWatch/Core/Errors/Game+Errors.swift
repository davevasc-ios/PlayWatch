//
//  Game+Errors.swift
//  PlayWatch
//
//  Created by David on 2/2/25.
//

import Foundation

enum GameError: LocalizedError {
    
    case outOfRange
    
    var errorDescription: String? {
        switch self {
        case .outOfRange:
            return "Data is out of range"
        }
    }
}
