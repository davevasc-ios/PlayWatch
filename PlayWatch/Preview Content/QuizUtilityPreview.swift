//
//  QuizUtilityPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct QuizUtilityPreview: QuizUtilityProtocol {
    
    let settingsUtility: SettingsUtilityProtocol
    
    func createRequest(movies: String, aiServer: AIServer) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: aiServer.testResource, withExtension: PreviewConstants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
