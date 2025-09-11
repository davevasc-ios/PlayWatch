//
//  MediaUtilityPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

struct MediaUtilityPreview: MediaUtilityProtocol {
    
    func createRequest(mediaType: MediaFetchType, searchQuery: String?) throws -> URLRequest {
        guard let url = Bundle.main.url(forResource: mediaType.testResource, withExtension: PreviewConstants.Resource.Extension.json) else {
            throw API.Error.invalidURL
        }
        return URLRequest(url: url)
    }
}
