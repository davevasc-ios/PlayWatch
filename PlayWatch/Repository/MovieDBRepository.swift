//
//  MovieDBRepository.swift
//  PlayWatch
//
//  Created by David on 24/10/24.
//

import Foundation

protocol MovieDBRepositoryProtocol: Sendable {
    func createRequest(resourceName: String?, type: MovieDB.FetchType?, locale: MovieDB.Locale?, searchText: String?) throws -> URLRequest
}

extension MovieDBRepositoryProtocol {
    func fetchMediaByType(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String?) async throws -> [Media] {
        let data = try await self.fetchData(request: self.createRequest(resourceName: nil, type: type, locale: locale, searchText: searchText))
        return try await self.fetchMedia(data: data)
    }
    
    func fetchMediaByTest(resourceName: String) async throws -> [Media] {
        let data = try await self.fetchData(request: self.createRequest(resourceName: resourceName, type: nil, locale: nil, searchText:nil))
        return try await self.fetchMedia(data: data)
    }
    
    private func fetchData(request: URLRequest) async throws-> Data {
        if let url = request.url, url.isFileURL {
            return try Data(contentsOf: url)
        } else {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == HTTP.successCode else {
                throw API.Error.invalidResponse(detail: String(data: data, encoding: .utf8).orEmpty)
            }
            return data
        }
    }
    
    private func fetchMedia(data: Data) async throws -> [Media] {
        do {
            return try JSONDecoder.convertFromSnakeCase.decode(MediaResponseDTO.self, from: data).results?.map(\.toMedia) ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData(detail: error.localizedDescription)
        }
    }
}

struct MovieDBRepository: MovieDBRepositoryProtocol {
    internal func createRequest(resourceName: String?, type: MovieDB.FetchType?, locale: MovieDB.Locale?, searchText: String?) throws -> URLRequest {
        let url = try MovieDB.Endpoint.mediaDataUrl(type: type ?? .searchAll, locale: locale ?? MovieDB.Locale.init(), searchText: searchText)
        return HTTP.request(url: url, method: .get, fields: MovieDB.Endpoint.headerFields)
    }
}

struct MovieDBRepositoryTest: MovieDBRepositoryProtocol {
    internal func createRequest(resourceName: String?, type: MovieDB.FetchType?, locale: MovieDB.Locale?, searchText: String?) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
