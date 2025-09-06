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
        imageUrl: MovieDBUtils.getImageURL(file: "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg", size: .small),
        name: "Deadpool & Wolverine",
        date: "2024-07-24".toDate(),
        rating: 7.71
    )
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
