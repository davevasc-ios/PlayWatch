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
    
    // MARK: - API variables
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
    
    // MARK: - Custom variables
    var mediaImage: String {
        return self.posterPath.isValue ? self.posterPath.getValue : (self.profilePath.isValue ? self.profilePath.getValue : "")
    }
    var mediaName: String {
        return self.title.isValue ? self.title.getValue : (self.name.isValue ? self.name.getValue : "")
    }
    var mediaOriginalName: String {
        return self.originalTitle.isValue ? self.originalTitle.getValue : (self.originalName.isValue ? self.originalName.getValue : "")
    }
    var mediaReleaseDate: Date? {
        if let date = self.releaseDate, date != "" {
            return ISO8601DateFormatter().date(from: date)
        } else if let date = self.firstAirDate, date != "" {
            return ISO8601DateFormatter().date(from: date)
        } else {
            return nil
        }
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
    case person = "person"
}

struct MediaSection: Identifiable {
    var id = UUID()
    let title: String
    let items: [Media]
}
