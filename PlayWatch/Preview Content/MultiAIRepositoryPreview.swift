//
//  MultiAIRepositoryPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct MultiAIRepositoryPreview: MultiAIRepositoryProtocol {
    func createRequest(config: GameRequestConfig) throws -> URLRequest {
        try Bundle.main.jsonURLRequest(for: config.aiServer.testResource)
    }
}
