//
//  Media.swift
//  PlayWatch
//
//  Created by David on 17/12/24.
//

import Foundation

struct Media: Identifiable, Hashable, Sendable {
    let id: Int
    let type: MediaType
    let imageUrl: URL?
    let name: String
    let date: Date?
    let rating: Double?
}

// MARK: - Extensions
extension Media {
    static let test = Media(
        id: 533535,
        type: .movie,
        imageUrl: MovieDB.getImageUrl(file: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", size: .medium),
        name: "Deadpool & Wolverine",
        date: MovieDB.getDate(date: "2024-07-24"),
        rating: 7.71
    )
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
