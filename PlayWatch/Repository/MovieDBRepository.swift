//
//  MovieDBRepository.swift
//  PlayWatch
//
//  Created by David on 24/10/24.
//

import Foundation

protocol MovieDBRepositoryProtocol {
    func createRequest() throws -> URLRequest
}

extension MovieDBRepositoryProtocol {
    func fetchMedia() async throws -> [Media] {
        let data = try await self.fetchData(request: self.createRequest())
        do {
            return try JSONDecoder.convertFromSnakeCase.decode(MediaResponseDTO.self, from: data).results?.map(\.toMedia) ?? []
        } catch {
            print("Error decoding JSON: \(error)")
            throw API.Error.invalidData(detail: error.localizedDescription)
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
}

struct MovieDBRepository: MovieDBRepositoryProtocol {
    var type: MovieDB.FetchType
    var locale: MovieDB.Locale
    var searchText: String?
    
    internal func createRequest() throws -> URLRequest {
        let url = try MovieDB.Endpoint.mediaDataUrl(type: type, locale: locale, searchText: searchText)
        return HTTP.request(url: url, method: .get, fields: MovieDB.Endpoint.headerFields)
    }
}

struct MovieDBRepositoryTest: MovieDBRepositoryProtocol {
    var resourceName: String
    
    internal func createRequest() throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: self.resourceName, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
