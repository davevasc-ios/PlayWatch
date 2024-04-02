//
//  MovieDBService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

// MARK: - Protocol declaration
protocol MovieDBServiceProtocol {
    func fetchCinema() async throws -> [Movie]
}

final class MovieDBService: MovieDBServiceProtocol {
    
    // MARK: - External functions (for ViewModel)
    func fetchCinema() async throws -> [Movie] {
//        let (data, response) = try await URLSession.shared.data(for: MdbAPI.request(url: MdbAPI.cinemaURL()))
        let (data, response) = try await URLSession.shared.data(for: MdbAPI.request(mode: MdbAPI.Fetch.cinema))
        guard let response = response as? HTTPURLResponse, response.statusCode == HTTP.StatusCode.success else {
            throw API.Error.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Movies.self, from: data).results
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
    
}
