//
//  MediaUtilityPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct MediaUtilityPreview: MediaRopositoryProtocol {
    
    func createRequest(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: type.testResource, withExtension: PreviewConstants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
