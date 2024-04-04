//
//  Media.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

struct MediaResults: Codable {
  let results: [Media]?
}

struct Media: Codable {
    let id: Int
    let backdropPath: String?
    let title: String? // Optional for "movie" media type
    let name: String? // Optional for "person" and "tv" media type
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let mediaType: MediaType?
    let genreIds: [Int]?
    let firstAirDate: String? // Optional for "movie" media type
    let releaseDate: String? // Optional for "tv" media type
    let voteAverage: Double?
    let voteCount: Int?
    let knownFor: [Media]? // For "person" media
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
    case person = "person"
}


