//
//  BoolExtension.swift
//  PlayWatch
//
//  Created by David on 14/6/24.
//

import Foundation

extension Optional where Wrapped == Bool {
    var orTrue: Bool { self ?? true }
    var orFalse: Bool { self ?? false }
}

extension Bool {
    
}
