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
    
    // MARK: - API Variables
    let id: Int
    let mediaType: String?
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
    let knownForDepartment: String? // person
    let knownFor: [Media]? // person
    
    // MARK: - Custom Variables
    var media: MediaType {
        return MediaType(rawValue: self.mediaType ?? "") ??
        (self.firstAirDate.isValue ? .tv : (self.knownForDepartment.isValue ? .person : .movie))
    }
    var mediaImage: String {
        return self.posterPath.isValue ?
        self.posterPath.orEmpty :
        (self.profilePath.isValue ? self.profilePath.orEmpty : "")
    }
    var mediaName: String {
        return self.title.isValue ?
        self.title.orEmpty :
        (self.name.isValue ? self.name.orEmpty : "")
    }
    var mediaOriginalName: String {
        return self.originalTitle.isValue ?
        self.originalTitle.orEmpty :
        (self.originalName.isValue ? self.originalName.orEmpty : "")
    }
    var mediaReleaseDate: Date? {
        return self.releaseDate.isValue ?
        MovieDB.getDate(date: self.releaseDate.orEmpty) :
        (self.firstAirDate.isValue ? MovieDB.getDate(date: self.firstAirDate.orEmpty) : nil)
    }
}

enum MediaType: String, Codable {
    case movie,
         tv,
         person,
         all
}

enum MediaPeriod: String {
    case day,
         week
}

struct MediaSection: Identifiable {
    var id = UUID()
    let title: LocalizedStringResource
    let items: [Media]
}
