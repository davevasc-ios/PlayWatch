//
//  MediaLocale.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

struct MediaLocale: Hashable {
    var code: String = .empty
    var region: String = .empty
    var language: String {
        "\(code)-\(region)"
    }
}

struct GameData {
    var server: AIServer = .deepSeek
    var mediaLocale: MediaLocale = MediaLocale()
    var language: String = .empty
}
