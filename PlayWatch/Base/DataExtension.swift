//
//  DataExtension.swift
//  PlayWatch
//
//  Created by David on 15/12/24.
//

import Foundation

extension Data {
    var toUTF8String: String {
        String(data: self, encoding: .utf8) ?? "Failed to decode data to UTF-8 string."
    }
}
