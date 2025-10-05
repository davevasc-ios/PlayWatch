//
//  QuizUtilityPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct QuizUtilityPreview: QuizRepositoryProtocol {
    func createRequest(for movies: String, using server: AIServer, in language: String) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: server.testResource, withExtension: PreviewConstants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
