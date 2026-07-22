//
//  MediaContent.swift
//  PlayWatch
//
//  Created by David on 15/2/26.
//

import Foundation

// TODO: - CONTINUAR CON LA NUEVA ARQUITECTURA SEPARADA DE MEDIA

// MARK: - Protocolo base (evitamos conflicto con Content del sistema)
nonisolated protocol MediaContent: Identifiable, Codable, Hashable, Sendable {
    var id: String { get }
    var title: String { get }
    var posterURL: URL? { get }
    var backdropURL: URL? { get }
}


protocol MovieDBMovieContent: MediaContent {
    
}




nonisolated protocol MediaContentProtocol: Identifiable, Codable, Hashable, Sendable {
    var id: String { get }
    var posterURL: URL? { get }
}


protocol MovieContentProtocol: MediaContentProtocol {
    var title: String { get }
    var originalTitle: String { get }
    var originalLanguage: String { get }
    var releaseDate: String? { get }
    
    var backdropURL: URL? { get }
    
    
    
    
    var overview: String { get }
    
    var runtime: Int? { get }
    var rating: Double? { get }
}

protocol TVShowContentProtocol: MediaContentProtocol {
    var name: String { get }
    var originalName: String { get }
    var originalLanguage: String { get }
    var firstAirDate: String? { get }
    
    var genreIds: [String] { get }
    var backdropURL: URL? { get }
    
    
    
    var overview: String { get }
    
    var runtime: Int? { get }
    var rating: Double? { get }
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
