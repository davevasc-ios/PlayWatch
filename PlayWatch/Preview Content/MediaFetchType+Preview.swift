//
//  MediaFetchType+Preview.swift
//  PlayWatch
//
//  Created by David on 1/2/25.
//

import Foundation

extension MediaFetchType {
    var testResource: String {
        switch self {
        case .randomMovies, .cinemaPlaying, .cinemaUpcomimg, .movieTrending, .movieNew:
            PreviewConstants.Resource.Name.movies
        case .tvTrending, .tvNew:
            PreviewConstants.Resource.Name.tvShows
        case .personTrending, .personPopular:
            PreviewConstants.Resource.Name.people
        default:
            PreviewConstants.Resource.Name.all
        }
    }
}
