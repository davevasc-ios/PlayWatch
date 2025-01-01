//
//  MediaMapper.swift
//  PlayWatch
//
//  Created by David Vicente on 1/1/25.
//

import Foundation

struct MediaMapper {
    static func map(dto: [MediaDTO]) -> [Media] {
        dto.map(\.toMedia)
    }
}
