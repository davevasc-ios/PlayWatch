//
//  MediaRepositoryPreview.swift
//  PlayWatch
//
//  Created by David on 19/12/24.
//

import Foundation

#if DEBUG

struct MediaRepositoryPreview: MediaRepositoryProtocol {
        
    var simulatedDelay: Duration = .seconds(0.5)
    
    func fetchMedia(for type: MediaFetchType, with locale: MediaLocale, searchQuery: String?) async throws -> [Media] {
        try await Task.sleep(for: simulatedDelay)
        
        return switch type {
        case .cinemaPlaying, .cinemaUpcomimg, .movieNew, .movieTrending, .randomMovies: Media.previewMovieList
        case .tvNew, .tvTrending: Media.previewTVList
        case .personPopular, .personTrending: Media.previewPersonList
        case .searchAll, .trendingAll: Media.previewAllList
        }
        
    }
}

#endif
