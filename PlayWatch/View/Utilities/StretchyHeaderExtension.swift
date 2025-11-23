//
//  StretchyHeaderExtension.swift
//  PlayWatch
//
//  Created by David on 23/11/25.
//

import SwiftUI

extension View {
    func stretchyHeader () -> some View {
        visualEffect { effect, geometry in
            let currentHeight = geometry.size.height
            let scrollOffset = geometry.frame(in: .scrollView).minY
            let positiveOffset = max(0, scrollOffset)
            let scaleFactor = (currentHeight + positiveOffset) / currentHeight
            return effect
                .scaleEffect(x: scaleFactor, y: scaleFactor, anchor: .bottom)
        }
    }
}
