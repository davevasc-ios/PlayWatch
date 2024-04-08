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

struct Media: Codable, Identifiable {
    let id: Int
    let mediaType: MediaType?
    let posterPath: String?
    let profilePath: String? // person
    let originalLanguage: String?
    let overview: String?
    let genreIds: [Int]?
    let title: String? // movie
    let name: String? // tv, person
    let originalTitle: String? // movie
    let originalName: String? // tv, person
    let releaseDate: String? // movie
    let firstAirDate: String? // tv
    let voteAverage: Double?
    let voteCount: Int?
    let KnownForDepartment: String? // person
    let knownFor: [Media]? // person
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
    case person = "person"
}


