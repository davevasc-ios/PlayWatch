//
//  TV.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

struct TVResults: Codable {
    let results: [TV]?
}

struct TV: Codable {
    let id: Int
    let genreIds: [Int]?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let firstAirDate: String?
    let name: String?
    let voteAverage: Double?
    let voteCount: Int?
}
