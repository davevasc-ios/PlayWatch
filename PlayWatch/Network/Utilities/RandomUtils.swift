//
//  RandomUtils.swift
//  PlayWatch
//
//  Created by David on 16/1/25.
//

import Foundation

struct RandomUtils {
    static var randomShortBy: String {
        let randomShortBy = MovieDB.validShortBy.randomElement() ?? .popularity
        let randomShortDirection = MovieDB.SortDirection.allCases.randomElement() ?? .asc
        return "\(randomShortBy.rawValue)\(randomShortDirection.rawValue)"    }
}
