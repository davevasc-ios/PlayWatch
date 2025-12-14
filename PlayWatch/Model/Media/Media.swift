//
//  Media.swift
//  PlayWatch
//
//  Created by David on 17/12/24.
//

import Foundation

struct Media: Identifiable, Hashable {
    let id: Int
    let type: MovieDBType
    let backdropUrl: URL?
    let imageUrl: URL?
    let name: String
    let date: Date?
    let rating: Double?
}

extension Array where Element == Media {
    var filterWithImage: [Element] {
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


#if DEBUG
// MARK: - Extensions

extension Array where Element == Media {
    static let preview: [Media] = (0..<20).map { i in
        Media(
            id: i,
            type: Media.preview.type,
            backdropUrl: Media.preview.backdropUrl,
            imageUrl: Media.preview.imageUrl,
            name: "\(Media.preview.name) \(i + 1)", // "Deadpool & Wolverine 1", etc.
            date: Media.preview.date,
            rating: Media.preview.rating
        )
    }
}

extension Media {
    static let preview = Media(
        id: 533535,
        type: .movie,
        backdropUrl: MovieDBUtils.getImageURL(file: "/oBIQDKcqNxKckjugtmzpIIOgoc4.jpg", size: .original),
        imageUrl: MovieDBUtils.getImageURL(file: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", size: .small),
        name: "Deadpool & Wolverine",
        date: "2024-07-24".toDate(),
        rating: 7.71
    )
    
    static let previewImageError = Media(
        id: 533535,
        type: .movie,
        backdropUrl: MovieDBUtils.getImageURL(file: "/error.jpg", size: .original),
        imageUrl: MovieDBUtils.getImageURL(file: "/error.jpg", size: .small),
        name: "Deadpool & Wolverine",
        date: "2024-07-24".toDate(),
        rating: 7.71
    )
}
#endif
