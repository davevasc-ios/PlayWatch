//
//  MovieDBRepository.swift
//  PlayWatch
//
//  Created by David on 24/10/24.
//

import Foundation

enum RepositoryType {
    case live, test
}

protocol MovieDBRepositoryProtocol: Sendable {
    var repositoryType: RepositoryType { get }
}

extension MovieDBRepositoryProtocol {
    
    func fetchMedia(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String? = nil) async throws -> [Media] {
        let request = try self.createRequest(type: type, locale: locale, searchText: searchText)
        let data = try await self.fetchData(request: request)
        return try await self.fetchMedia(data: data)
    }
        
    private func createRequest(type: MovieDB.FetchType, locale: MovieDB.Locale, searchText: String? = nil) throws -> URLRequest {
        switch self.repositoryType {
        case .live:
            let url = try MovieDB.Endpoint.mediaDataUrl(type: type, locale: locale, searchText: searchText)
            return HTTP.request(url: url, method: .get, fields: MovieDB.Endpoint.headerFields)
        case .test:
            guard let url = Bundle.main.url(forResource: type.testResource, withExtension: Constants.Resource.Extension.json) else {
                throw API.Error.invalidURL
            }
            return URLRequest(url: url)
        }
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
    var repositoryType: RepositoryType {
        .live
    }
}

struct MovieDBRepositoryTest: MovieDBRepositoryProtocol {
    var repositoryType: RepositoryType {
        .test
    }
}
