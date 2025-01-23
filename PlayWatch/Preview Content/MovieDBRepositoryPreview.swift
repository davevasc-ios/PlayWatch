//
//  MovieDBRepositoryPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct MovieDBRepositoryPreview: MovieDBRepositoryProtocol {
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: config.mediaType.testResource, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
