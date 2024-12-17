//
//  MediaSection.swift
//  PlayWatch
//
//  Created by David on 17/12/24.
//

import Foundation

struct MediaSection: Identifiable {
    var id = UUID()
    let title: LocalizedStringResource
    let items: [Media]
}
