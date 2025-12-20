//
//  MediaSection.swift
//  PlayWatch
//
//  Created by David on 17/12/24.
//

import Foundation

struct MediaSection: Identifiable, Hashable {
    var id = UUID()
    let type: SectionType
    let items: [Media]
}

#if DEBUG
extension MediaSection {
    
    /// A single section preview containing multiple copies of the mock media.
    static let preview = MediaSection(
        id: UUID(),
        type: .randomMovies,
        items: Media.previewMovieList
    )
    
}
#endif

