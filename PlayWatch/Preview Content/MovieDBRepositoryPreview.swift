//
//  MovieDBRepositoryPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct MovieDBRepositoryPreview: MovieDBRepositoryProtocol {
    func createRequest(config: MediaRequestConfig) throws -> URLRequest {
        try Bundle.main.jsonURLRequest(for: config.mediaType.testResource)
    }
}
