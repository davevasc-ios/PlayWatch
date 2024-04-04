//
//  MovieDBService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

// MARK: - Protocol declaration
protocol MovieDBServiceProtocol {
    func fetchCinema(query: MdbAPI.QueryData) async throws -> [Movie]
    func fetchTrend(query: MdbAPI.QueryData) async throws -> [Movie]
}

final class MovieDBService: MovieDBServiceProtocol {
    
    // MARK: - External functions (for ViewModel)
    
    func fetchTrend(query: MdbAPI.QueryData) async throws -> [Movie] {
        let (data, response) = try await URLSession.shared.data(for: MdbAPI.request(query: query))
        guard let response = response as? HTTPURLResponse, response.statusCode == HTTP.StatusCode.success else {
            throw API.Error.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieResults.self, from: data).results ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
    
    func fetchCinema(query: MdbAPI.QueryData) async throws -> [Movie] {
        let (data, response) = try await URLSession.shared.data(for: MdbAPI.request(query: query))
        guard let response = response as? HTTPURLResponse, response.statusCode == HTTP.StatusCode.success else {
            throw API.Error.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieResults.self, from: data).results ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
    
    /// juntar Movie y TV en un Media unico???
    // TODO: COMING
    func fetchComing(query: MdbAPI.QueryData) async throws -> [Movie] {
        let (data, response) = try await URLSession.shared.data(for: MdbAPI.request(query: query))
        guard let response = response as? HTTPURLResponse, response.statusCode == HTTP.StatusCode.success else {
            throw API.Error.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieResults.self, from: data).results ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
    
    // TODO: stream
    func fetchStream(query: MdbAPI.QueryData) async throws -> [Movie] {
        let (data, response) = try await URLSession.shared.data(for: MdbAPI.request(query: query))
        guard let response = response as? HTTPURLResponse, response.statusCode == HTTP.StatusCode.success else {
            throw API.Error.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieResults.self, from: data).results ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
    
    // TODO: search all
    func fetchSearch(query: MdbAPI.QueryData) async throws -> [Media] {
        let (data, response) = try await URLSession.shared.data(for: MdbAPI.request(query: query))
        guard let response = response as? HTTPURLResponse, response.statusCode == HTTP.StatusCode.success else {
            throw API.Error.invalidResponse
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MediaResults.self, from: data).results ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData
        }
    }
    
}
