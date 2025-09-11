//
//  MediaLocale.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

struct MediaLocale {
    var code: String = .empty
    var region: String = .empty
    var language: String {
        "\(code)-\(region)"
    }
}
