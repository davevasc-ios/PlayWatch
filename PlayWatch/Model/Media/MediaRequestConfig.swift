//
//  MediaRequestConfig.swift
//  PlayWatch
//
//  Created by David Vicente on 24/12/24.
//

import Foundation

struct MediaRequestConfig {
    let mediaType: MovieDB.FetchType
    let locale: MovieDB.Locale
    let searchQuery: String?
    
    init(mediaType: MovieDB.FetchType, locale: MovieDB.Locale, searchQuery: String? = nil) {
        self.mediaType = mediaType
        self.locale = locale
        self.searchQuery = searchQuery
    }
}
