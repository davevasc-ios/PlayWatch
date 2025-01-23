//
//  MultiAIRepositoryPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct MultiAIRepositoryPreview: MultiAIRepositoryProtocol {
    func createRequest(config: GameRequestConfig) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: config.aiServer.testResource, withExtension: Constants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
