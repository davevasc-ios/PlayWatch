//
//  MediaContent.swift
//  PlayWatch
//
//  Created by David on 15/2/26.
//

import Foundation


// MARK: - Protocolo base (evitamos conflicto con Content del sistema)
nonisolated protocol MediaContent: Identifiable, Codable, Hashable, Sendable {
    var id: String { get }
    var title: String { get }
    var posterURL: URL? { get }
    var backdropURL: URL? { get }
}

// MARK: - Modelos específicos
struct Movie: MediaContent {
    let id: String
    let title: String
    let posterURL: URL?
    let backdropURL: URL?
    let releaseDate: String?
    let runtime: Int?
    let rating: Double?
}

struct TVShow: MediaContent, Codable {
    let id: String
    let title: String
    let posterURL: URL?
    let backdropURL: URL?
    let firstAirDate: String?
    let numberOfSeasons: Int?
    let rating: Double?
}

struct Person: MediaContent, Sendable {
    let id: String
    let name: String
    let profilePath: URL?
    let backdropPath: URL?
    let knownFor: String?
    let popularity: Double?
    
    var title: String { name }
    var posterURL: URL? { profilePath }
    var backdropURL: URL? { backdropPath }
}

struct Game: MediaContent, Sendable {
    let id: String
    let title: String
    let posterURL: URL?
    let backdropURL: URL?
    let releaseDate: String?
    let platforms: [String]?
    let rating: Double?
}
