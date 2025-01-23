//
//  URLConfig.swift
//  PlayWatch
//
//  Created by David on 22/1/25.
//

import Foundation

protocol URLConfigProtocol: Sendable {
    var baseURL: String { get }
    func path(type: MovieDB.FetchType) -> String
    func queryItems(config: MediaRequestConfig) -> [URLQueryItem]
}

extension URLConfigProtocol {
    func createURL(config: MediaRequestConfig) throws -> URL {
        let path = self.path(type: config.mediaType)
        guard let fullURL = URL(string: self.baseURL + path),
              var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: true) else {
            throw API.Error.invalidURL
        }
        components.queryItems = self.queryItems(config: config)
        guard let finalURL = components.url else {
            throw API.Error.invalidURL
        }
        return finalURL
    }
}

struct MovieDBURLConfig: URLConfigProtocol {
    static let imageURL = Constants.imageURL
    var baseURL = Constants.baseURL
    func path(type: MovieDB.FetchType) -> String {
        Constants.paths[type].orEmpty
    }
    func queryItems(config: MediaRequestConfig) -> [URLQueryItem] {
        config.mediaType.queryParameters(for: config.locale, searchText: config.searchQuery)
    }
}
// TODO: - OpenAI y Gemini URLConfig


//struct OpenAIURLConfig: URLConfigProtocol {
//
//}

//struct GeminiURLConfig: URLConfigProtocol {
//
//}
