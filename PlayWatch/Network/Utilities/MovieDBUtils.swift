//
//  MovieDBUtils.swift
//  PlayWatch
//
//  Created by David on 27/1/25.
//

import Foundation

struct MovieDBUtils {
    
    static var randomShortBy: String {
        let randomShortBy = MovieDBConstants.validShortBy.randomElement() ?? .popularity
        let randomShortDirection = MovieDBSorting.SortDirection.allCases.randomElement() ?? .asc
        return "\(randomShortBy.rawValue)\(randomShortDirection.rawValue)"
    }
    
    static func getImageURL(file: String?, size: MovieDBImageSize = .medium) -> URL? {
        guard let file else { return nil }
        return URL(string: "\(MovieDBConstants.baseImageURL)\(size.rawValue)\(file)")
    }
}
