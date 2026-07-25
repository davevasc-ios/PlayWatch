//
//  SettingsUtilityPreview.swift
//  PlayWatch
//
//  Created by David on 11/9/25.
//

import Foundation

#if DEBUG

extension SettingsKeys {
    static let preview = SettingsKeys(
        theme: "preview.settings.theme",
        language: "preview.settings.language",
        region: "preview.settings.region",
        server: "preview.settings.server"
    )
}

struct SettingsUtilityPreview: SettingsManaging {
    var keys: SettingsKeys = .preview
}

#endif
