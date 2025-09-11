//
//  QuizUtilityPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct QuizUtilityPreview: QuizUtilityProtocol {
    var settingsUtility: any SettingsReadable
        
    func createRequest(movies: String) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: settingsUtility.selectedServer.testResource, withExtension: PreviewConstants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
