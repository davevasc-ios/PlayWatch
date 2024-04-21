//
//  ArrayExtension.swift
//  PlayWatch
//
//  Created by David on 21/4/24.
//

import Foundation

extension Array where Element == Media {
    func filterWithImage() -> [Element] {
        return self.filter { $0.mediaImage != "" }
    }
}
