//
//  EnvironmentValues+ScreenSize.swift
//  PlayWatch
//
//  Created by David on 24/5/24.
//

import SwiftUI

private struct ScreenSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}
