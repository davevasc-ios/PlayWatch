//
//  Media.swift
//  PlayWatch
//
//  Created by David on 5/4/24.
//

import Foundation

struct MediaModel: Codable {
    let results: [MediaDTO]?
}

struct MediaDTO: Codable {
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
              imageUrl: self.getImageUrl(),
              name: self.getName(),
              date: self.getDate(),
              rating: self.voteAverage)
    }
    
    func getType() -> MediaType {
        if let mediaTypeString = mediaType?.ifNotEmpty,
           let mediaType = MediaType(rawValue: mediaTypeString) {
            return mediaType
        } else if firstAirDate.isNotNil {
            return .tv
        } else if knownForDepartment.isNotNil {
            return .person
        }
        return .movie
    }
    
    func getImageUrl() -> URL? {
        let path = posterPath?.ifNotEmpty ?? profilePath?.ifNotEmpty
        return MovieDB.getImageUrl(file: path, size: .medium)
    }
    
    func getName() -> String {
        self.title?.ifNotEmpty ?? self.name?.ifNotEmpty ?? .empty
    }
    
    func getDate() -> Date? {
        let date = self.releaseDate?.ifNotEmpty ?? self.firstAirDate?.ifNotEmpty
        return MovieDB.getDate(date: date)
    }
}

struct Media: Identifiable, Hashable, Sendable {
    let id: Int
    let type: MediaType
    let imageUrl: URL?
    let name: String
    let date: Date?
    let rating: Double?
}

extension Media {
    static let test = Media(id: 533535,
                            type: .movie,
                            imageUrl: MovieDB.getImageUrl(file: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", size: .medium),
                            name: "Deadpool & Wolverine",
                            date: MovieDB.getDate(date: "2024-07-24"),
                            rating: 7.71)
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
        self.filter { $0.imageUrl != nil }
    }
    
    func joinedNames(separator: String = .commaSeparator) -> String {
        self.map { $0.name }.joined(separator: separator)
    }
}

extension Optional where Wrapped == [Media] {
    var orEmpty: [Media] {
        self ?? []
    }
}

extension MediaModel {
    static func decode(from data: Data) throws -> [Media] {
        do {
            let model = try JSONDecoder.convertFromSnakeCase.decode(Self.self, from: data)
            return (model.results?.map(\.toMedia)).orEmpty
        } catch {
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}
