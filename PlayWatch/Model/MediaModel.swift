//
//  Media.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

struct MediaResponseDTO: Codable {
    let results: [MediaDTO]?
}

struct MediaDTO: Codable {
    // MARK: - API Variables
    let id: Int
    let mediaType: String?
    let posterPath: String?
    let profilePath: String?
    let title: String?
    let name: String?
    let releaseDate: String?
    let firstAirDate: String?
    let voteAverage: Double?
    let knownForDepartment: String?
}

extension MediaDTO {
    var toMedia: Media {
        Media(id: self.id,
              type: self.getType(),
              image: self.getImage(),
              name: self.getName(),
              date: self.getDate(),
              rating: self.voteAverage)
    }
    
    func getType() -> MediaType {
        MediaType(rawValue: self.mediaType.orEmpty) ??
        (self.firstAirDate.isValue ?
            .tv :
            (self.knownForDepartment.isValue ? .person : .movie))
    }
    
    func getImage() -> String {
        self.posterPath.isValue ?
        self.posterPath.orEmpty :
        (self.profilePath.isValue ? self.profilePath.orEmpty : "")
    }
    
    func getName() -> String {
        self.title.isValue ?
        self.title.orEmpty :
        (self.name.isValue ? self.name.orEmpty : "")
    }
    
    func getDate() -> Date? {
        self.releaseDate.isValue ?
        MovieDB.getDate(date: self.releaseDate.orEmpty) :
        (self.firstAirDate.isValue ? MovieDB.getDate(date: self.firstAirDate.orEmpty) : nil)
    }
}

struct Media: Identifiable, Hashable, Sendable {
    let id: Int
    let type: MediaType
    let image: String
    let name: String
    let date: Date?
    let rating: Double?
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

extension Array where Element == Media {
    func filterWithImage() -> [Element] {
        return self.filter { $0.image != "" }
    }
    
    func joinedNames(separator: String = ", ") -> String {
        return self.map { $0.name }.joined(separator: separator)
    }
}
