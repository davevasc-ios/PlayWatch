//
//  MovieDBService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

// MARK: - Protocol declaration
protocol MovieDBServiceProtocol {
    
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media]
}

final class MovieDBService: MovieDBServiceProtocol {
    
    // MARK: - External functions (for ViewModel)
    
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media] {
        let (data, response) = try await URLSession.shared.data(for: MovieDB.getRequest(type: type, locale: locale, searchText: searchText))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MediaResults.self, from: data).results ?? []
        } catch {
//            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
    
}
