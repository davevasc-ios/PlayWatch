//
//  MediaDTO.swift
//  PlayWatch
//
//  Created by David on 17/12/24.
//

import Foundation

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

// MARK: - DTO to Domain Mapping
extension MediaDTO {
    var toMedia: Media {
        Media(
            id: self.id,
            type: self.resolvedMediaType,
            imageUrl: self.resolvedImageUrl,
            name: self.resolvedName,
            date: self.resolvedDate,
            rating: self.voteAverage
        )
    }
    
    private var resolvedMediaType: MediaType {
        if let mediaType = self.mediaType.flatMap(MediaType.init) {
            return mediaType
        } else if self.firstAirDate.isNotNil {
            return .tv
        } else if self.knownForDepartment.isNotNil {
            return .person
        }
        return .movie
    }
    
    private var resolvedImageUrl: URL? {
        let path = self.posterPath?.ifNotEmpty ?? self.profilePath?.ifNotEmpty
        return MovieDB.getImageUrl(file: path, size: .medium)
    }
    
    private var resolvedName: String {
        self.title?.ifNotEmpty ?? self.name?.ifNotEmpty ?? .empty
    }
    
    private var resolvedDate: Date? {
        let dateString = self.releaseDate?.ifNotEmpty ?? self.firstAirDate?.ifNotEmpty
        return dateString?.toDate()
    }
}

extension Optional where Wrapped == [MediaDTO] {
    var orEmpty: [MediaDTO] {
        self ?? []
    }
}

extension Array where Element == MediaDTO {
    var mapToMedia: [Media] {
        self.map(\.toMedia)
    }
}
