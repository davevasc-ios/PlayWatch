//
//  MovieDBService.swift
//  PlayWatch
//
//  Created by David on 31/3/24.
//

import Foundation

protocol MovieDBServiceProtocol: Sendable {
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media]
}

final class MovieDBService: MovieDBServiceProtocol {

    internal func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media] {
        let (data, response) = try await URLSession.shared.data(request: MovieDB.getRequest(type: type, locale: locale, searchText: searchText))
        guard let response = response as? HTTPURLResponse,
              response.statusCode == HTTP.successCode else {
            throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MediaResults.self, from: data).results ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
    
    // parece ser más eficiente, comprobar mejor y preguntar queue label:
//    private var currentFetchTask: Task<[Media], Error>?
//    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media] {
//        currentFetchTask?.cancel()
//        currentFetchTask = Task {
//            let (data, response) = try await URLSession.shared.data(for: MovieDB.getRequest(type: type, locale: locale, searchText: searchText))
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == HTTP.successCode else {
//                throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
//            }
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
//            return try decoder.decode(MediaResults.self, from: data).results ?? []
//        }
//        guard let task = currentFetchTask else {
//            throw API.Error.invalidData(detail: "")
//        }
//        return try await task.value
//    }
}
