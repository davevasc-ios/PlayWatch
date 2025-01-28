//
//  MediaRequestConfig.swift
//  PlayWatch
//
//  Created by David Vicente on 24/12/24.
//

import Foundation

struct MediaRequestConfig {
    let mediaType: MediaFetchType
    let locale: MediaLocale
    let searchQuery: String?
    
    init(mediaType: MediaFetchType, locale: MediaLocale, searchQuery: String? = nil) {
        self.mediaType = mediaType
        self.locale = locale
        self.searchQuery = searchQuery
    }
}
