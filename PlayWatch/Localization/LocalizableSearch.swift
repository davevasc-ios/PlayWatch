//
//  LocalizableSearch.swift
//  PlayWatch
//
//  Created by David on 22/11/25.
//

import Foundation

extension Localizable {
    
    // MARK: - Table LocalizableSearch
    enum Search {
        
        static let title = LocalizedStringResource(
            "search.section.title",
            defaultValue: "Search",
            table: "LocalizableSearch",
            comment: "Search section title"
        )
        static let searchBar = LocalizedStringResource(
            "search.searchBar.placeholder",
            defaultValue: "Search by movie, tv or person",
            table: "LocalizableSearch",
            comment: "Placeholder of search bar"
        )
    }
}
